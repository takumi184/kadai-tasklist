class TasksController < ApplicationController
    before_action :require_user_logged_in
    before_action :correct_user, only: [:destroy,:edit, :show]
    before_action :set_task, only: [:show, :edit, :update, :destroy]

    def index
       @tasks = current_user.tasks
    end
    
    def new
        @task = Task.new
    end
    
    def create
        @task = current_user.tasks.build(task_params)
        if @task.save
         flash[:success] = 'タスクを投稿しました。'
         redirect_to root_url
        else
         @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
         flash.now[:danger] = 'タスクの投稿に失敗しました。'
         render 'new'
        end
    end
    
    def show
    end
    
    def edit
    end
    
    def update
        if @task.update(task_params)
          flash[:success] = 'タスクは正常に更新されました'
          redirect_to @task
        else
          flash.now[:danger] = 'タスクは更新されませんでした'
          render :edit
        end
    end
    
    def destroy
        @task.destroy
        flash[:success] = 'タスクは正常に削除されました'
        # redirect_back(fallback_location: root_path)
        redirect_to tasks_url
    end
    
    private
    
    def task_params
     params.require(:task).permit(:content)
    end
    
    
    def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def set_task
    end

    def correct_user
     @task = current_user.tasks.find_by(id: params[:id])
     unless @task
      redirect_to root_url
     end
    end
   
    
    # Strong Parameter
    def task_params
        params.require(:task).permit(:content, :status)
    end
end
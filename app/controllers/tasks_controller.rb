class TasksController < ApplicationController
    before_action :require_user_logged_in, only: [:index, :show]
    before_action :require_user_logged_in
    before_action :correct_user, only: [:destroy]
    
    def index
    if logged_in?
      @pagy, @tasks = pagy(Task.order(id: :desc), items: 25)
      @task = current_user.tasks.build  # form_with 用
      @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
    end
    end
    
    def show
        @task = Task.find(params[:id])
        @pagy, @tasks = pagy(@task.tasks.order(id: :desc))
        counts(@task)
    end
    
    def new
        @task = Task.new
    end
    
    def create
        @task = current_user.tasks.build(micropost_params)
        if @task.save
         flash[:success] = 'メッセージを投稿しました。'
         redirect_to root_url
        else
         @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
         flash.now[:danger] = 'メッセージの投稿に失敗しました。'
         render 'index'
        end
    end
    
    def edit
    end
    
    def update
        if @task.update(task_params)
          flash[:success] = 'Task は正常に更新されました'
          redirect_to @task
        else
          flash.now[:danger] = 'Task は更新されませんでした'
          render :edit
        end
    end
    
    def destroy
        @task.destroy

        flash[:success] = 'Task は正常に削除されました'
        redirect_back(fallback_location: root_path)
    end
    
    private
    
    def task_params
    params.require(:task).permit(:content)
    end
    
    def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
    end
    

    def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def set_task
    @task = Task.find(params[:id])
    end


    # Strong Parameter
    def task_params
        params.require(:task).permit(:content, :status)
    end
end

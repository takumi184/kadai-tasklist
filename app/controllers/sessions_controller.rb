class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    if login(email, password)
      flash[:success] = 'ログインに成功しました。'
      redirect_to @task
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render :new
    end
  end

  def destroy
  end
  
  private

  def login(email, password)
    @task = Task.find_by(email: email)
    if @task && @task.authenticate(password)
      # ログイン成功
      session[:user_id] = @task.id
      return true
    else
      # ログイン失敗
      return false
    end
  end
end

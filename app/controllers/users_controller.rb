require 'prawn'
class UsersController < ApplicationController
  def index
    role = Role.find(params['role_id']) if params['role_id']
    @role_name = role.present? ? role.name : "Select Role"
    puts @role_name
    @users = !role.present? ? User.all.paginate(page: params[:page], per_page: 10) : role.users.paginate(page: params[:page], per_page: 10)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    role = Role.find(params["user"]["role_id"])
    @user.roles << role
    respond_to do |format|
      if @user.save
        UserMailer.welcome_email(@user).deliver_now
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update!(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }

        format.json { render :show, status: :ok }
      else
        format.html { render :update, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path, notice: 'User was successfully destroyed.'
  end

  def download_users_pdf
    @users = User.all

    pdf = Prawn::Document.new
    pdf.text 'Users List', size: 18, style: :bold

    @users.each do |user|
      pdf.text "#{user.id}: #{user.first_name} #{user.last_name} - #{user.email}"
    end

    send_data pdf.render, type: 'application/pdf', filename: 'users.pdf'
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :image)
    end
end
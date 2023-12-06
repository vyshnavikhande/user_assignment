class RolesController < ApplicationController
  def index
    @roles = Role.all
  end

  def new
    @role = Role.new
  end

  def show
    @role = Role.find(params[:id])
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    byebug
    @role = Role.new(name: params["role"]["name"])
    respond_to do |format|
      if @role.save
        format.html { redirect_to role_url(@role), notice: "Role was successfully created." }
        format.json { render :show, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @role = Role.find(params[:id])
    respond_to do |format|
      if @role.update!(name: params["role"]["name"])
        format.html { redirect_to role_url(@role), notice: "Role was successfully updated." }

        format.json { render :show, status: :ok }
      else
        format.html { render :update, status: :unprocessable_entity }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    redirect_to roles_path, notice: 'Role was successfully destroyed.'
  end
end
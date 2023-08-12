class Public::ReportsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @report = Report.new(report_params)
    @report.reporter_id = current_user.id
    @report.reported_id = @user.id
    if @report.save
      flash[:notice] = "通報しました"
      redirect_to recipes_public_user_path(@user)
    else
      flash[:alert] = "通報に失敗しました"
      render :new
    end
  end
  
  private

  def report_params
    params.require(:report).permit(:reason)
  end
end

class Admin::ReportController < ApplicationController
  def index
    @reports = Report.all
    @users = User.all
  end

  def show
    @report = Report.find(params[:id])
    @recipes = @user.recipes
    @user = User.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    if @report.update(report_params)
      redirect_to admin_user_reports_path
    end
  end

  private

  def report_params
    params.require(:report).permit(:checked)
  end
end

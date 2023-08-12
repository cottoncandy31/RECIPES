class Admin::ReportsController < ApplicationController
  def index
    @reports = Report.order(created_at: :desc) # 新着順に並ぶよう設定
    @users = User.all
  end

  def show
    @report = Report.find(params[:id])
    @reported = User.find(@report.reported_id)
    @reporter = User.find(@report.reporter_id)
  end

  def update
    @report = Report.find(params[:id])
    if @report.update(report_params)
      redirect_to admin_reports_path
    end
  end

  private

  def report_params
    params.require(:report).permit(:check)
  end
end

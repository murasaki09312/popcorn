module Admin
  class WorksController < BaseController
    before_action :set_work, only: %i[show edit update destroy]

    def index
      @works = Work.with_attached_thumbnail.order(created_at: :desc)
    end

    def show
    end

    def new
      @work = Work.new
    end

    def create
      @work = Work.new(work_params)

      if @work.save
        redirect_to admin_work_path(@work), notice: "作品を作成しました。"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @work.update(work_params)
        redirect_to admin_work_path(@work), notice: "作品を更新しました。"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @work.destroy
      redirect_to admin_works_path, status: :see_other, notice: "作品を削除しました。"
    end

    private
      def set_work
        @work = Work.find(params[:id])
      end

      def work_params
        params.require(:work).permit(:title, :video_url, :tags, :description, :thumbnail)
      end
  end
end

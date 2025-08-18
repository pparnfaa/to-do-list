class QuestsController < ApplicationController
  before_action :set_quest, only: %i[ show edit update destroy toggle ]

  def toggle
    @quest.update(status: !@quest.status)
    redirect_to quests_path, notice: "Quest updated."
  end

  # GET /quests
  def index
    @quests = Quest.order(created_at: :asc)
  end

  def show; end
  def new; @quest = Quest.new; end
  def edit; end

  def create
    @quest = Quest.new(quest_params)
    if @quest.save
      redirect_to quests_path, notice: "Quest was successfully created."
    end
  end

  def update
    if @quest.update(quest_params)
      redirect_to quests_path, notice: "Quest was successfully updated."
    end
  end

  def destroy
    @quest.destroy!
    respond_to do |format|
      format.html { redirect_to quests_path, status: :see_other, notice: "Quest was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_quest
      @quest = Quest.find(params[:id])
    end

    def quest_params
      params.require(:quest).permit(:name, :status)
    end
end

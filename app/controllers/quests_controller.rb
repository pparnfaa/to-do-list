class QuestsController < ApplicationController
  before_action :set_quest, only: %i[ show edit update destroy toggle ]

  def toggle
    @quest.update(status: !@quest.status)
    redirect_to quests_path, notice: "Quest updated."
  end


  # GET /quests or /quests.json
  def index
    @quests = Quest.all
    @quests = Quest.order(created_at: :asc)
  end

  # GET /quests/1 or /quests/1.json
  def show
  end

  # GET /quests/new
  def new
    @quest = Quest.new
  end

  # GET /quests/1/edit
  def edit
  end

  # POST /quests or /quests.json
  def create
    @quest = Quest.new(quest_params)
    if @quest.save
      redirect_to quests_path, notice: "Quest was successfully created."
    end
  end


  # PATCH/PUT /quests/1 or /quests/1.json
  def update
    @quest = Quest.find(params[:id])
    if @quest.update(quest_params)
      redirect_to quests_path, notice: "Quest was successfully updated."
    end
  end


  # DELETE /quests/1 or /quests/1.json
  def destroy
    @quest.destroy!

    respond_to do |format|
      format.html { redirect_to quests_path, status: :see_other, notice: "Quest was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quest
      @quest = Quest.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def quest_params
      params.expect(quest: [ :name, :status ])
    end
end

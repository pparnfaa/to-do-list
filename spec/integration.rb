# spec/requests/quests_spec.rb
require 'rails_helper'

RSpec.describe "Quests", type: :request do
  describe "GET /quests" do
    it "returns 200 and renders index" do
      get quests_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("My Academy Quest") # จาก data-testid page-title
    end
  end

  describe "POST /quests" do
    context "with valid params" do
      it "creates a quest and redirects to index" do
        expect {
          post quests_path, params: { quest: { name: "Learn RSpec", status: false } }
        }.to change(Quest, :count).by(1)

        expect(response).to redirect_to(quests_path)
        follow_redirect!

        # ไม่เช็ค flash แล้ว เช็คว่า item โผล่ใน list แทน
        expect(response.body).to include("Learn RSpec")
      end
    end

    context "with invalid params" do
      it "creates even with blank name and redirects to index" do
        expect {
          post quests_path, params: { quest: { name: "" } }
        }.to change(Quest, :count).by(1)

        expect(response).to redirect_to(quests_path)
        follow_redirect!
        expect(response.body).to include("Quests") # หรือจะ include data-testid/page-title
      end
    end
  end

  describe "PATCH /quests/:id" do
    let!(:quest) { Quest.create!(name: "Old Name", status: false) }

    context "with valid params" do
      it "updates and redirects to index" do
        patch quest_path(quest), params: { quest: { name: "New Name" } }
        expect(response).to redirect_to(quests_path)
        expect(quest.reload.name).to eq("New Name")
      end
    end

    context "with invalid params" do
      it "updates with blank name and redirects to index (no validations)" do
        patch quest_path(quest), params: { quest: { name: "" } }

        expect(response).to have_http_status(:found) # 302
        expect(response).to redirect_to(quests_path)
        expect(quest.reload.name).to eq("")          # อัปเดตเป็นค่าว่างจริง
      end
    end
  end

  describe "POST /quests/:id/toggle" do
    let!(:quest) { Quest.create!(name: "Toggle me", status: false) }

    it "toggles status and redirects to index" do
      post toggle_quest_path(quest)
      expect(response).to redirect_to(quests_path)
      expect(quest.reload.status).to eq(true)

      post toggle_quest_path(quest)
      expect(quest.reload.status).to eq(false)
    end
  end

  describe "DELETE /quests/:id" do
    let!(:quest) { Quest.create!(name: "Delete me", status: false) }

    it "destroys and redirects with 303 See Other" do
      expect {
        delete quest_path(quest)
      }.to change(Quest, :count).by(-1)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(quests_path)
    end
  end
end

# spec/system/quests_spec.rb
require 'rails_helper'

RSpec.describe "Quests", type: :system do
  # helper ง่าย ๆ สำหรับสร้างข้อมูล
  def create_quest(name:, status: false)
    Quest.create!(name: name, status: status)
  end

  it "แสดงหัวข้อและโปรไฟล์ครบ" do
    visit quests_path

    expect(page).to have_css("[data-testid='page-root']")
    expect(page).to have_css("[data-testid='page-title']", text: "My Academy Quest")
    expect(page).to have_css("[data-testid='profile-name']", text: "Parnfa Phathabannaporn")
    expect(page).to have_css("[data-testid='profile-image']")
    expect(page).to have_css("[data-testid='brag-button']")
    expect(page).to have_css("[data-testid='add-quest-form']")
    expect(page).to have_css("[data-testid='quest-input']")
    expect(page).to have_css("[data-testid='add-quest']")
    expect(page).to have_css("[data-testid='quest-list']")
  end

  it "เพิ่ม Quest ใหม่ได้ และโชว์ในรายการ" do
    visit quests_path

    find("[data-testid='quest-input']").fill_in(with: "Learn RSpec System Test")
    find("[data-testid='add-quest']").click

    # ตรวจว่ามีรายการใหม่เกิดขึ้น
    within("[data-testid='quest-list']") do
      expect(page).to have_text("Learn RSpec System Test")
    end
  end

  it "toggle สถานะแล้วเปลี่ยนสไตล์เป็นขีดฆ่า", js: true do
    q = create_quest(name: "Write system tests", status: false)
    visit quests_path

    # ก่อน toggle ยังไม่ขีดฆ่า
    expect(page).to have_css("[data-testid='quest-name-#{q.id}'].text-gray-800")

    # กด checkbox เพื่อ toggle
    find("[data-testid='quest-toggle-#{q.id}']").click

    # กลับมาหน้า index อีกครั้งหลัง form submit (rack_test จะรีเฟรชตาม form)
    # ตรวจว่ากลายเป็นขีดฆ่าแล้ว
    expect(page).to have_css("[data-testid='quest-name-#{q.id}'].line-through.text-gray-400")
  end

  it "ลบ Quest ได้ (มี confirm) แล้วหายจากรายการ", js: true do
    q1 = create_quest(name: "Task to delete", status: false)
    q2 = create_quest(name: "Task to keep",  status: false)
    visit quests_path

    within("[data-testid='quest-list']") do
      expect(page).to have_css("[data-testid='quest-item-#{q1.id}']")
      expect(page).to have_css("[data-testid='quest-item-#{q2.id}']")
    end

    accept_confirm "Delete this quest?" do
      find("[data-testid='quest-delete-button-#{q1.id}']").click
    end

    within("[data-testid='quest-list']") do
      expect(page).to have_no_css("[data-testid='quest-item-#{q1.id}']")
      expect(page).to have_css("[data-testid='quest-item-#{q2.id}']")
    end
  end


  it "คลิกปุ่ม brag แล้วไปหน้าบันทึก brag document ได้" do
    visit quests_path
    find("[data-testid='brag-button']").click
    # ปรับ expectation ด้านล่างตามหัวข้อ/องค์ประกอบในหน้า brag document ของโปรเจกต์จริง
    expect(page).to have_current_path(brag_document_index_path)
  end

  it "กดลิงก์แก้ไขที่เป็น overlay ของแต่ละรายการได้" do
    q = create_quest(name: "Edit me", status: false)
    visit quests_path

    # หาลิงก์แก้ไขจาก data-testid ที่ฝังไว้บน overlay link
    find("[data-testid='quest-edit-link-#{q.id}']").click
    expect(page).to have_current_path(edit_quest_path(q))
  end
end

require 'helper'
require 'note_class'

class TestCatchNotes < Test::Unit::TestCase
  
  def setup
    NoteClass.good_user
  end
  
  should "have valid login info" do
    assert_instance_of Class, NoteClass
    assert NoteClass.valid_username?, "Need a username to connect"
    assert NoteClass.valid_password?, "Need a password to connect"
  end
  
  should "be able to get all notes as an array of notes" do
    notes = NoteClass.all
    assert_instance_of Array, notes
    assert_instance_of NoteClass, notes.first
  end
  
  should "be able to get the first note" do
    assert_instance_of NoteClass, NoteClass.first
  end
  
  should "be able to get the last note" do
    assert_instance_of NoteClass, NoteClass.last
  end
  
  should "be able to find a note by its id" do
    note = NoteClass.find 42
    assert_instance_of NoteClass, note
  end
  
  should "be able to create and save a new note" do
    text = 'This is a new note.'
    note = NoteClass.new :text=> text
    assert note.new_record?
    assert note.save
    assert !note.new_record?
    assert_equal text, note.text
  end
  
  should "be able to update an existing note" do
    note = NoteClass.first
    note.text= "This is the new text"
    assert note.save
  end
  
  should "be able to delete a note" do
    note = NoteClass.first
    assert_nothing_raised do
      note.destroy!
    end
    assert note.destroy
  end
  
  should "not be able to delete a new note" do
    note = NoteClass.new :text => "Hello World"
    assert !note.destroy
  end
  
  should "raise a nil error when a note doesn't exist: find" do
    assert_nil NoteClass.find 13
  end
  
  
  should "raise a NotFound error when a note doesn't exist: find!" do
    assert_raise CatchNotes::NotFound do
      NoteClass.find! 13
    end
  end
  
  should "not be able to access listing with bad username and password" do
    NoteClass.bad_user
    assert_raise CatchNotes::AuthError do
      NoteClass.all
    end
  end
  
  should "not allow a bad user to create a note" do
    NoteClass.bad_user
    assert_raise CatchNotes::AuthError do
      NoteClass.new(:text=>"Bad note").save!
    end
  end
  
  should "not allow a bad user to delete a note" do
    note = NoteClass.first
    NoteClass.bad_user
    assert_raise CatchNotes::AuthError do
      note.destroy!
    end
  end
  
end

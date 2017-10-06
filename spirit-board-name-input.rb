#===============================================================================
# Name Input Interface (v1.2)
# Author: jetpackgone
# Compatible with RPG Maker VX Ace
# Last updated: October 5, 2017
# 
# Feel free to use and share, but please credit me if you choose to use
#  or adapt this script in any way.
#===============================================================================
# Features:
# - Reduces Name Input Processing window to minimalist form with only capital 
#   letters and numbers.
# - Width and position of windows are customizable by changing the parameters.
# - Letters are displayed in an parabolic arc, while numbers are in a line.
# - Windows are always horizontally centered.
# - Maximum number of characters is 16.
# - See demo for example.
#===============================================================================
# Version
# 1.0 - Original
# 1.1 - Fixed window width for demo
# 1.2 - Modified to make window dimensions customizable
#     - Arranged letters to display in arcs and added numbers
#     - (Requested by Outrightsmile)
#===============================================================================

#===============================================================================
# Customizable parameters
module JETPACKGONE_MINIMALIST_NAME_INPUT_PARAMS
  PARABOLA = 0.3           # steepness of parabola for letters
  BOTTOM_ROW_POSITION = 1  # position of number row
  BOTTOM_WINDOW_HEIGHT = 7 # height of bottom input window
  UPPER_WINDOW_HEIGHT = 3  # height of upper display window
  WINDOW_POSITION = 10     # position of upper and bottom windows
  WINDOW_WIDTH = 450       # Should always be > number of columns * 32
end
# Do not edit below this line! (unless you know what you're doing)
#===============================================================================

#==============================================================================
# ** Window_NameEdit
#------------------------------------------------------------------------------
#  This window is used to edit an actor's name on the name input screen.
#==============================================================================
class Window_NameEdit < Window_Base
  include JETPACKGONE_MINIMALIST_NAME_INPUT_PARAMS
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :name                     # name
  attr_reader   :index                    # cursor position
  attr_reader   :max_char                 # maximum number of characters
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor, max_char)
    x = Graphics.width / 2 - WINDOW_WIDTH / 2
    y = (Graphics.height - (fitting_height(WINDOW_POSITION) + 8)) / 2
    super(x, y, WINDOW_WIDTH + 4, fitting_height(UPPER_WINDOW_HEIGHT))
    @actor = actor
    @max_char = max_char
    @default_name = @name = actor.name[0, @max_char]
    @index = @name.size
    deactivate
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Width of Face Graphic
  #--------------------------------------------------------------------------
  def face_width
    return 0
  end
  #--------------------------------------------------------------------------
  # * Get Character Width
  #--------------------------------------------------------------------------
  def char_width
    text_size($game_system.japanese? ? "あ" : "A").width + 4
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Displaying Item
  #--------------------------------------------------------------------------
  def item_rect(index)
    Rect.new(left + index * char_width, 36, char_width, line_height)
  end
  #--------------------------------------------------------------------------
  # * Get Left Coordinate of Name
  #--------------------------------------------------------------------------  
  def left
    name_center = (contents_width + face_width) / 2
    name_width = (@max_char + 1) * char_width
    return [name_center - name_width / 2, contents_width - name_width].min
  end
  #--------------------------------------------------------------------------
  # * Get Underline Rectangle
  #--------------------------------------------------------------------------
  def underline_rect(index)
    rect = item_rect(index)
    rect.x += 1
    rect.y += rect.height - 4
    rect.width -= 2
    rect.height = 2
    rect
  end
  #--------------------------------------------------------------------------
  # * Get Underline Color
  #--------------------------------------------------------------------------
  def underline_color
    color = normal_color
    color.alpha = 48
    color
  end
  #--------------------------------------------------------------------------
  # * Draw Text
  #--------------------------------------------------------------------------
  def draw_char(index)
    rect = item_rect(index)
    rect.x -= -3
    rect.width += 4
    change_color(normal_color)
    draw_text(rect, @name[index] || "")
  end
end


#==============================================================================
# ** Window_NameInput
#------------------------------------------------------------------------------
#  This window is used to select text characters on the name input screen.
#==============================================================================
class Window_NameInput < Window_Selectable
  include JETPACKGONE_MINIMALIST_NAME_INPUT_PARAMS
  #--------------------------------------------------------------------------
  # * Character Tables (Latin)
  #--------------------------------------------------------------------------
  LATIN3 = ['A','B','C','D','E','F','G','H','I','J','K','L','M',
            'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
            '' ,'1','2','3','4','5','6','7','8','9','0','' ,'OK']
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(edit_window)
    super(edit_window.x,
          edit_window.y+edit_window.height,
          edit_window.width,
          fitting_height(BOTTOM_WINDOW_HEIGHT))
    @edit_window = edit_window
    @page = 0
    @index = 0
    refresh
    update_cursor
    activate
  end
  #--------------------------------------------------------------------------
  # * Get Text Table
  #--------------------------------------------------------------------------
  def table
    return [LATIN3]
  end
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def jpg_columns
    13
  end
  #--------------------------------------------------------------------------
  # * Get Text Character
  #--------------------------------------------------------------------------
  def character
    @index < 37 ? table[@page][@index] : ""
  end
  #--------------------------------------------------------------------------
  # * Determine Cursor Location: Confirmation
  #--------------------------------------------------------------------------
  def is_ok?
    @index == LATIN3.length - 1
  end
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def jpg_x(index)
    dist = index - (jpg_columns / 2) + 1
    dist * dist * PARABOLA
  end
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def jpg_sign(index)
    jpg_x(index) > 0 ? 1 : -1
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Displaying Item
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    columnBuffer = (jpg_columns % 2 == 0 ? jpg_columns : jpg_columns + 0.5) / 2 * 32
    firstIndexLastRow = LATIN3.length - jpg_columns
    rowIndex = index % jpg_columns
    newIndex = rowIndex - 1
    rowBuffer = index > firstIndexLastRow - 1 ? line_height * BOTTOM_ROW_POSITION : jpg_x(newIndex) * jpg_sign(newIndex)
    buffer = WINDOW_WIDTH / 2 - columnBuffer
    rect.width = 32
    rect.height = line_height
    rect.x = rowIndex * 32 + rowIndex / jpg_columns * 16 + buffer
    rect.y = index / jpg_columns * line_height + 4 * rowBuffer
    rect
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(normal_color)
    LATIN3.length.times {|i| draw_text(item_rect(i), table[@page][i], 1) }
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #     wrap : Wraparound allowed
  #--------------------------------------------------------------------------
  def cursor_down(wrap)
    firstIndexLastRow = LATIN3.length - jpg_columns
    if @index < firstIndexLastRow or wrap
      @index = (index + jpg_columns) % LATIN3.length
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #     wrap : Wraparound allowed
  #--------------------------------------------------------------------------
  def cursor_up(wrap)
    firstIndexLastRow = LATIN3.length - jpg_columns
    if @index >= jpg_columns or wrap
      @index = (index + firstIndexLastRow) % LATIN3.length
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Right
  #     wrap : Wraparound allowed
  #--------------------------------------------------------------------------
  def cursor_right(wrap)
    if @index % jpg_columns < jpg_columns - 1
      @index += 1
    elsif wrap
      @index -= (jpg_columns - 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Left
  #     wrap : Wraparound allowed
  #--------------------------------------------------------------------------
  def cursor_left(wrap)
    if @index % jpg_columns > 0
      @index -= 1
    elsif wrap
      @index += (jpg_columns - 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Jump to OK
  #--------------------------------------------------------------------------
  def process_jump
    okIndex = LATIN3.length - 1
    if @index != okIndex
      @index = okIndex
      Sound.play_cursor
    end
  end
end

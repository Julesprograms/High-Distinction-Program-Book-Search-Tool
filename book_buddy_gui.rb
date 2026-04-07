# Import necessary Ruby gems and libraries
require 'rubygems'   # RubyGems is a package management framework for Ruby
require 'gosu'       # Gosu is a 2D game development library for Ruby
require 'csv'        # CSV library for handling CSV file operations
require 'date'       # Date library for handling dates

# Define color constants using Gosu's Color class
LIGHT_GRAY = Gosu::Color.new(0xffd3d3d3)       # ARGB: opaque light gray
BRIGHT_YELLOW = Gosu::Color.new(0xffffd700)   # ARGB: opaque bright yellow (Gold color)
TRANSPARENT_LIGHT_GRAY = Gosu::Color.new(0xC8000000)  # Semi-transparent light gray
TRANSPARENT_DARK_GRAY = Gosu::Color.new(0xDC1E1E1E)   # Semi-transparent dark gray

# Module for ZOrder to manage drawing layers (determines which objects appear on top)
module ZOrder
  BACKGROUND, BUTTON, BOOK, TEXT, OVERLAY, OVERLAY_TEXT, OWL = *0..6
  # ZOrder constants are assigned integer values from 0 to 6
  # Lower values are drawn first (appear behind higher values)
end

# Enumeration for Genres to standardize genre names and manage them easily
module Genre
  ALL = 'All'
  FICTION = 'Fiction'
  NON_FICTION = 'Non-Fiction'
  MYSTERY = 'Mystery'
  FANTASY = 'Fantasy'
  SCIENCE_FICTION = 'Science Fiction'
  BIOGRAPHY = 'Biography'
  HISTORY = 'History'
  ROMANCE = 'Romance'
  HORROR = 'Horror'
  OTHER = 'Other'

  # Array containing all genres for easy iteration and management
  ALL_GENRES = [
    ALL,
    FICTION,
    NON_FICTION,
    MYSTERY,
    FANTASY,
    SCIENCE_FICTION,
    BIOGRAPHY,
    HISTORY,
    ROMANCE,
    HORROR,
    OTHER
  ]
end

# Book class representing each book in the collection
class Book
  # Define getter and setter methods for book attributes
  attr_accessor :title, :author, :genre, :publication_date,
                :blurb, :awards, :publishing_house, :nationality,
                :cover_image_path, :author_photo_path, :average_rating, :user_rating

  # Initialize a Book object with provided attributes and default values
  def initialize(title, author, genre, publication_date, blurb = "",
                 awards = [], publishing_house = "", nationality = "",
                 cover_image_path = "", author_photo_path = "", average_rating = 0.0, user_rating = 0.0)
    @title = title
    @genre = genre
    @publication_date = publication_date
    @author = author
    @blurb = blurb
    @awards = awards
    @publishing_house = publishing_house
    @nationality = nationality
    @cover_image_path = cover_image_path
    @author_photo_path = author_photo_path
    @average_rating = average_rating
    @user_rating = user_rating
  end

  # Convert the Book object to a CSV-formatted string
  def to_csv
    [
      title, author, genre, publication_date,
      blurb, awards.join(';'), publishing_house,
      nationality, cover_image_path, author_photo_path, average_rating, user_rating
    ].to_csv
  end
end

# BookCollection class managing the collection of books and favourites
class BookCollection
  # Define getter and setter methods for books and favourites
  attr_accessor :books, :favourites

  # Initialize a BookCollection with empty books and favourites arrays
  def initialize
    @books = []
    @favourites = []
    
  end

  # Load books from a CSV file using while loops
  def load_books(file_name)
    file = File.open(file_name, 'r')  # Open the CSV file in read mode
    headers = file.gets               # Read the header line (column names)

    while (row = file.gets)           # Iterate through each subsequent line in the file
      data = CSV.parse_line(row)      # Parse the CSV line into an array of fields

      awards = []
      if data[5] && !data[5].empty?    # Check if the awards field exists and is not empty
        awards = data[5].split(';')    # Split awards by semicolon into an array
      end

      # Ensure the row has enough columns to prevent errors
      if data && data.size >= 12
        # Create a new Book object with the parsed data
        book = Book.new(
          data[0], # Title
          data[1], # Author
          data[2], # Genre
          data[3], # Publication Date
          data[4], # Blurb
          awards,  # Awards
          data[6], # Publishing House
          data[7], # Nationality
          data[8], # Cover Image Path
          data[9], # Author Photo Path
          data[10].to_f, # Average Rating converted to float
          data[11].to_f  # User Rating converted to float
        )
        @books << book                 # Add the new book to the books array
      end
    end

    file.close                          # Close the file after reading
    puts "#{@books.size} books loaded from #{file_name}."  # Output the number of books loaded
  end

  # Save favourite books to a CSV file using while loops
  def save_favourites(file_name)
    file = File.open(file_name, 'w')    # Open the CSV file in write mode
    # Define CSV headers
    headers = ['Title', 'Author', 'Genre', 'Publication Date', 'Blurb',
               'Awards', 'Publishing House', 'Nationality', 'Cover Image', 'Author Photo', 'Average Rating', "User Rating"].to_csv
    file.puts headers                    # Write the header line to the CSV file

    i = 0
    while i < @favourites.size             # Iterate through each favourite book
      book = @favourites[i]
      file.puts book.to_csv               # Write the book's CSV representation to the file
      i += 1
    end

    file.close                            # Close the file after writing
    puts "Favourites saved to #{file_name}."  # Output confirmation message
  end

  # Check if a book is in favourites by comparing title and author
  def favourite?(book)
    i = 0
    while i < @favourites.size
      fav = @favourites[i]
      if fav.title == book.title && fav.author == book.author
        return true                        # Return true if a matching book is found
      end
      i += 1
    end
    return false                           # Return false if no matching book is found
  end

  # Add a book to favourites if not already present
  

  # Remove a book from favourites
 
  def remove_favourite(book)
    i = 0
    while i < @favourites.size
      fav = @favourites[i]
      if fav.title == book.title && fav.author == book.author
        @favourites.delete_at(i)        # Remove the book from favourites
        puts "'#{book.title}' removed from favourites."  # Confirm removal
        return
      end
      i += 1
    end
    puts "'#{book.title}' was not found in favourites."   # Inform user if the book wasn't found
  end
end

def add_favourite(book) 
    
    duplicate = false
    i = 0
    while i < @favourites.size
      fav = @favourites[i]
      if fav.title == book.title && fav.author == book.author
        if @favourites? duplicate = true                    # Mark as duplicate if the book is already in favourites
        break 
        
         # Draw the appropriate button based on the favourite status
    if is_favourite
        @unfavourite_button.draw
      else
        @favourite_button.draw
      end
      end
      i += 1
    end

    if duplicate
      puts "'#{book.title}' is already in favourites."  # Inform user if the book is already a favourite
    else
      @favourites << book                # Add the book to favourites
      puts "'#{book.title}' added to favourites."     # Confirm addition
    end
  end






# Button class for creating interactive buttons with hover effects
class Button
  # Define getter and setter methods for button attributes
  attr_accessor :x, :y, :width, :height, :text, :id, :hovered, :zorder

  # Initialize a Button object with position, size, text, identifier, and colors
  def initialize(x, y, width, height, text, id, font, base_color, hover_color, zorder)
    @x = x                          # X-coordinate of the button's top-left corner
    @y = y                          # Y-coordinate of the button's top-left corner
    @width = width                  # Width of the button
    @height = height                # Height of the button
    @text = text                    # Text displayed on the button
    @id = id                        # Unique identifier for the button (used for event handling)
    @font = font                    # Font used for the button text
    @base_color = base_color        # Base color when the button is not hovered
    @hover_color = hover_color      # Color when the button is hovered
    @hovered = false                # Hover state of the button (true if mouse is over it)
    @zorder = zorder                # Z-order for rendering (determines drawing layer)
  end

  # Draw the button with a black thin outline and centered text
  def draw
    # Determine the button's background color based on hover state
    if @hovered
      color = @hover_color
    else
      color = @base_color
    end

    # Draw button outline (slightly larger to create a border effect)
    Gosu.draw_rect(@x - 2, @y - 2, @width + 4, @height + 4, Gosu::Color::BLACK, @zorder)
    # Draw button background
    Gosu.draw_rect(@x, @y, @width, @height, color, @zorder)

    # Calculate text positioning to center it within the button
    text_width = @font.text_width(@text)
    text_height = @font.height
    text_x = @x + (@width - text_width) / 2
    text_y = @y + (@height - text_height) / 2
    # Draw the button text
    @font.draw_text(@text, text_x, text_y, @zorder + 1, 1.0, 1.0, Gosu::Color::BLACK)
  end

  # Update hover state based on mouse position
  def is_mouse_over?(mouse_x, mouse_y)
    # Check if the mouse coordinates are within the button's boundaries
    @hovered = (mouse_x >= @x && mouse_x <= (@x + @width)) &&
               (mouse_y >= @y && mouse_y <= (@y + @height))
  end
end

# OwlCharacter class for managing the animated owl and its tooltips
class OwlCharacter
  # Define getter and setter methods for owl attributes
  attr_accessor :x, :y, :images, :current_frame, :animation_timer, :tooltip, :tooltip_timer

  # Initialize the OwlCharacter with position, images, tooltips, and reference to the main window
  def initialize(x, y, image_paths, tooltip_texts, window)
    @x = x                          # X-coordinate of the owl's position
    @y = y                          # Y-coordinate of the owl's position
    @images = []
    i = 0
    while i < image_paths.size        # Load each image path into Gosu::Image objects
      image = Gosu::Image.new(image_paths[i])
      @images << image                # Store the loaded images in an array
      i += 1
    end
    @current_frame = 0               # Current animation frame index
    @animation_timer = 0             # Timer to control animation frame changes
    @window = window                  # Reference to the main window for accessing shared resources
    @tooltip_texts = tooltip_texts    # Array of tooltip texts to display
    @tooltip = ""                     # Current tooltip text
    @tooltip_timer = 0                # Timer to control tooltip display duration
    @tooltip_interval = 10000         # Interval (in milliseconds) between tooltip displays
    @last_tooltip_time = Gosu.milliseconds  # Timestamp of the last tooltip display
    # Initialize the font once for drawing tooltips
    @font = Gosu::Font.new(20)
  end

  # Update animation frame and manage tooltip timing
  def update
    @animation_timer += 1
    if @animation_timer > 30  # Change frame every 30 update cycles (~0.5 seconds if 60 FPS)
      if @images.size > 0
        @current_frame = (@current_frame + 1) % @images.size  # Loop back to first frame after the last
      end
      @animation_timer = 0  # Reset the animation timer
    end

    # Manage tooltip display timing
    if Gosu.milliseconds - @last_tooltip_time > @tooltip_interval
      tooltip_index = rand(@tooltip_texts.size)  # Select a random tooltip
      @tooltip = @tooltip_texts[tooltip_index]  # Set the current tooltip
      @tooltip_timer = Gosu.milliseconds        # Record the time when tooltip was displayed
      @last_tooltip_time = Gosu.milliseconds   # Update the last tooltip display time
    end

    # Hide tooltip after it has been displayed for 5 seconds (5000 milliseconds)
    if @tooltip != "" && Gosu.milliseconds - @tooltip_timer > 5000
      @tooltip = ""  # Clear the tooltip text
    end
  end

  # Draw the owl and its tooltip
  def draw
    # Draw the current frame of the owl's animation
    @images[@current_frame].draw(@x, @y, ZOrder::OWL, 0.75, 0.75)

    # Draw the tooltip if it exists
    if @tooltip != ""
      text_width = @font.text_width(@tooltip)

      # Define offsets to position the tooltip lower and to the right of the owl
      tooltip_offset_x = 200  # Horizontal offset from the owl's position
      tooltip_offset_y = 50   # Vertical offset from the owl's position

      # Calculate tooltip's position based on offsets
      tooltip_x = @x + tooltip_offset_x
      tooltip_y = @y + tooltip_offset_y

      # Draw a semi-transparent gray rectangle as the tooltip background
      Gosu.draw_rect(tooltip_x, tooltip_y, text_width + 20, 30, Gosu::Color::GRAY, ZOrder::OWL)
      # Draw the tooltip text inside the rectangle with padding
      @font.draw_text(@tooltip, tooltip_x + 10, tooltip_y + 5, ZOrder::OWL + 1, 1.0, 1.0, Gosu::Color::WHITE)
    end
  end
end 

# DetailedView class for displaying comprehensive book information
class DetailedView
  # Define getter and setter methods for detailed view attributes
  attr_accessor :book, :close_button, :rating_buttons

  # Initialize the DetailedView with the selected book and UI components
  def initialize(book, window, font, small_font, star_full, star_empty, star_half)
    @book = book                            # The book to display in detail
    @window = window                        # Reference to the main window
    @font = font                            # Font for larger text
    @small_font = small_font                # Font for smaller text
    @star_full = star_full                  # Image for a full star (rating)
    @star_empty = star_empty                # Image for an empty star
    @star_half = star_half                  # Image for a half star

    # Initialize the close button for the detailed view
    @close_button = Button.new(
      window.width - 100, 50, 40, 40, "X", "close",
      font, Gosu::Color::RED, LIGHT_GRAY, ZOrder::OVERLAY
    )

    # Initialize favourite and unfavourite buttons
    @favourite_button = Button.new(
      150, 425, 200, 70, "    Favourite", "favourite",
      font, LIGHT_GRAY, LIGHT_GRAY, ZOrder::OVERLAY
    )
    @unfavourite_button = Button.new(
      150, 425, 200, 70, "       Unfavourite", "unfavourite",
      font, LIGHT_GRAY, LIGHT_GRAY, ZOrder::OVERLAY
    )

    # Create star buttons for user rating using a while loop
    @rating_buttons = []
    i = 0
    while i < 5
      star_x = 425 + i * 50               # Calculate x-position for each star
      star_y = 750                         # y-position for stars
      # Create a new Button for each star and add it to the rating_buttons array
      @rating_buttons << Button.new(
        star_x, star_y, 40, 40, "", "rate_#{i+1}",
        font, Gosu::Color::WHITE, Gosu::Color::YELLOW, ZOrder::OVERLAY
      )
      i += 1
    end

    @user_rating = @book.user_rating.to_i  # Initialize with the existing user rating
  end

  # Update hover states for buttons based on current mouse position
  def update(mouse_x, mouse_y, button_down)
    # Update hover state for the close button
    @close_button.hovered = @close_button.is_mouse_over?(mouse_x, mouse_y)

    # Iterate through rating buttons and update their hover states
    i = 0
    while i < @rating_buttons.size
      @rating_buttons[i].is_mouse_over?(mouse_x, mouse_y)
      i += 1
    end

    # Update hover states for favourite and unfavourite buttons
    @favourite_button.hovered = @favourite_button.is_mouse_over?(mouse_x, mouse_y)
    @unfavourite_button.hovered = @unfavourite_button.is_mouse_over?(mouse_x, mouse_y)
  end

  # Draw the detailed view with book information and interactive elements
  def draw
    # Draw a semi-transparent overlay to dim the background
    Gosu.draw_rect(0, 0, @window.width, @window.height, TRANSPARENT_LIGHT_GRAY, ZOrder::OVERLAY)

    # Define the position and size of the detailed information box
    box_x = 100
    box_y = 50
    box_width = @window.width - 200
    box_height = @window.height - 100
    # Draw the detailed information box with a semi-transparent dark gray background
    Gosu.draw_rect(box_x, box_y, box_width, box_height, TRANSPARENT_DARK_GRAY, ZOrder::OVERLAY)

    # Draw the book cover image if the file exists
    if File.exist?(@book.cover_image_path)
      cover = Gosu::Image.new(@book.cover_image_path)
      cover.draw(box_x + 50, box_y + 50, ZOrder::OVERLAY, 0.5, 0.5)  # Scale down the cover image
    else
      # If cover image is missing, draw a placeholder rectangle
      Gosu.draw_rect(box_x + 50, box_y + 50, 200, 300, LIGHT_GRAY, ZOrder::OVERLAY)
    end

    # Draw the author's photo if the file exists
    if File.exist?(@book.author_photo_path)
      author_photo = Gosu::Image.new(@book.author_photo_path)
      author_photo.draw(box_x + 25, box_y + 475, ZOrder::OVERLAY, 0.5, 0.5)  # Scale down the author photo
    else
      # If author photo is missing, draw a placeholder rectangle
      Gosu.draw_rect(box_x + 25, box_y + 475, 500, 500, LIGHT_GRAY, ZOrder::OVERLAY)
    end

    # Draw the author's name below the photo
    @font.draw_text(book.author, box_x + 25, box_y + 750, ZOrder::OVERLAY_TEXT, 1.5, 1.5, Gosu::Color::WHITE)

    # Define the position for book information text
    info_x = box_x + 300
    info_y = box_y + 50
    # Draw the book's title with larger font
    @font.draw_text(@book.title, info_x, info_y, ZOrder::OVERLAY_TEXT, 2.0, 2.0, Gosu::Color::WHITE)
    # Draw the author's name with slightly smaller font
    @font.draw_text("By #{@book.author}", info_x, info_y + 60, ZOrder::OVERLAY_TEXT, 1.5, 1.5, Gosu::Color::YELLOW)
    # Draw the genre of the book
    @font.draw_text("Genre: #{@book.genre}", info_x, info_y + 110, ZOrder::OVERLAY_TEXT, 1.25, 1.25, Gosu::Color::WHITE)
    # Draw the publication date
    @font.draw_text("Publication Date: #{@book.publication_date}", info_x, info_y + 150, ZOrder::OVERLAY_TEXT, 1.25, 1.25, Gosu::Color::WHITE)
    # Draw the blurb label
    @font.draw_text("Blurb:", info_x, info_y + 200, ZOrder::OVERLAY_TEXT, 1.5, 1.5, Gosu::Color::YELLOW)
    # Draw the blurb text with word wrapping
    @window.draw_text_wrapped(@font, @book.blurb, info_x, info_y + 240, box_width - 350, Gosu::Color::WHITE, ZOrder::OVERLAY_TEXT, 1.0, 1.0)

    # Draw the awards section
    @font.draw_text("Awards:", info_x, info_y + 300, ZOrder::OVERLAY_TEXT, 1.25, 1.25, Gosu::Color::YELLOW)
    awards_text = @book.awards.join(', ')  # Convert awards array to a comma-separated string
    @window.draw_text_wrapped(@font, awards_text, info_x, info_y + 330, box_width - 350, Gosu::Color::WHITE, ZOrder::OVERLAY_TEXT, 1.0, 1.0)

    # Draw the publishing house information
    @font.draw_text("Publishing House:", info_x, info_y + 380, ZOrder::OVERLAY_TEXT, 1.25, 1.25, Gosu::Color::YELLOW)
    @font.draw_text(@book.publishing_house, info_x, info_y + 410, ZOrder::OVERLAY_TEXT, 1.0, 1.0, Gosu::Color::WHITE)

    # Draw the average rating label
    @font.draw_text("Average Rating (Amazon/Google):", info_x, info_y + 460, ZOrder::OVERLAY_TEXT, 1.25, 1.25, Gosu::Color::YELLOW)
    # Draw the star ratings based on the average rating
    draw_stars(info_x + 25, info_y + 500, @book.average_rating)

    # Draw the label for adding user rating
    @font.draw_text("Add your rating:", info_x, info_y + 600, ZOrder::OVERLAY_TEXT, 1.25, 1.25, Gosu::Color::YELLOW)

    # Draw the star buttons for user rating
    draw_stars(info_x + 25, info_y + 650, @book.user_rating)

    # Load the favourite icon image
    favourite = Gosu::Image.new("assets/buttons/favourite_heart.png")
    is_favourite = @window.book_collection.favourite?(@book)  # Check if the book is already a favourite

   

    # Draw the favourite icon on the button
    favourite.draw(160, 435, ZOrder::OVERLAY, 0.5, 0.5)

    # Draw the close button to exit the detailed view
    @close_button.draw
  end

  # Handle click events within the detailed view
  def handle_click(mouse_x, mouse_y)
    # Check if the close button was clicked
    if @close_button.hovered
      @window.close_detailed_view          # Close the detailed view
      return
    end

    # Check if any rating button was clicked
    i = 0
    while i < @rating_buttons.size
      star = @rating_buttons[i]
      if star.hovered
        # Determine which rating was clicked based on the button's ID
        if star.id == "rate_1"
          submit_rating(1)                   # Submit a 1-star rating
        elsif star.id == "rate_2"
          submit_rating(2)                   # Submit a 2-star rating
        elsif star.id == "rate_3"
          submit_rating(3)                   # Submit a 3-star rating
        elsif star.id == "rate_4"
          submit_rating(4)                   # Submit a 4-star rating
        elsif star.id == "rate_5"
          submit_rating(5)                   # Submit a 5-star rating
        end
        return                               # Exit after handling the rating
      end
      i += 1
    end

    # Check if favourite/unfavourite buttons were clicked
    is_favourite = @window.book_collection.favourite?(@book)

    if is_favourite    
      if @unfavourite_button.hovered
        @window.book_collection.remove_favourite(@book)  # Remove the book from favourites
        @window.save_favourites                           # Save the updated favourites list
        return
      end
    else
      if @favourite_button.hovered
        add_favourite(book, book_collection.favourites)     # Add the book to favourites
        @window.save_favourites                           # Save the updated favourites list
        return
      end
    end
  end

  # Draw stars based on the rating (supports full, half, and empty stars)
  def draw_stars(x, y, rating)
    full_stars = rating.to_f.floor                # Number of full stars
    if (rating.to_f - full_stars) >= 0.5
      half_star = 1                                # Include a half star if applicable
    else
      half_star = 0
    end
    empty_stars = 5 - full_stars - half_star      # Remaining stars are empty

    i = 0
    # Draw full stars
    while i < full_stars
      @star_full.draw(x + i * 45, y, ZOrder::OVERLAY_TEXT, 0.5, 0.5)
      i += 1
    end
    # Draw half star if applicable
    if half_star == 1
      @star_half.draw(x + i * 45, y, ZOrder::OVERLAY_TEXT, 0.5, 0.5)
      i += 1
    end
    # Draw empty stars
    while i < 5
      @star_empty.draw(x + i * 45, y, ZOrder::OVERLAY_TEXT, 0.5, 0.5)
      i += 1
    end
    # Draw the numeric rating next to the stars
    @font.draw_text(rating, x + 240, y + 12, ZOrder::OVERLAY_TEXT, 1.25, 1.25, Gosu::Color::WHITE)
  end

  # Submit a rating for the book
  def submit_rating(rating)
    if rating >= 1 && rating <= 5
      @book.user_rating = rating.to_f        # Update the book's user rating
      @user_rating = rating                  # Update the internal user rating tracker
      @window.book_collection.add_favourite(@book)  # Ensure the book is in favourites
      @window.save_favourites                     # Save the updated favourites list
      puts "You rated '#{@book.title}' with #{rating} stars."  # Output confirmation
    end
  end
end

# FavouritesView class for displaying favourite books in a grid layout
class FavouritesView
  BOOKS_PER_PAGE = 8                        # Number of books to display per page
  ROWS = 2                                  # Number of rows in the grid
  COLUMNS = 4                               # Number of columns in the grid

  # Define getter and setter methods for FavouritesView attributes
  attr_accessor :close_button, :current_page, :total_pages, :visible_favourites

  # Initialize the FavouritesView with references to the window and book collection
  def initialize(window, book_collection, font, small_font, star_full, star_empty, star_half)
    @window = window                            # Reference to the main window
    @book_collection = book_collection          # Reference to the BookCollection
    @font = font                                # Font for larger text
    @small_font = small_font                    # Font for smaller text
    @star_full = star_full                      # Image for a full star (rating)
    @star_empty = star_empty                    # Image for an empty star
    @star_half = star_half                      # Image for a half star
    @close_button = Button.new(
      window.width - 100, 50, 40, 40, "X", "close",
      @font, Gosu::Color::RED, LIGHT_GRAY, ZOrder::OVERLAY
    )  # Initialize the close button for the favourites view

    # Pagination setup
    @current_page = 1                            # Start at the first page
    @total_pages = calculate_total_pages          # Calculate total number of pages
    update_visible_favourites                     # Update the list of books visible on the current page

    # Initialize pagination buttons only if there's more than one page
    if @total_pages > 1
      box_x = 100
      box_y = 50
      box_width = window.width - 200
      box_height = window.height - 100

      # Initialize Previous Button for navigating to the previous page
      @prev_button = Button.new(
        box_x + box_width / 2 - 150, box_y + box_height - 80,
        100, 40, "Previous", "prev_fav",
        @font, Gosu::Color::GRAY, LIGHT_GRAY, ZOrder::OVERLAY
      )

      # Initialize Next Button for navigating to the next page
      @next_button = Button.new(
        box_x + box_width / 2 + 50, box_y + box_height - 80,
        100, 40, "Next", "next_fav",
        @font, Gosu::Color::GRAY, LIGHT_GRAY, ZOrder::OVERLAY
      )
    end
  end  

  # Method to calculate total pages based on the number of favourite books
  def calculate_total_pages
    if @book_collection.favourites.empty?
      return 0                                 # Return 0 if there are no favourites
    else
      return (@book_collection.favourites.size / BOOKS_PER_PAGE.to_f).ceil  # Calculate pages, rounding up
    end
  end

  # Update the list of books visible on the current page
  def update_visible_favourites
    start_index = (@current_page - 1) * BOOKS_PER_PAGE  # Calculate the starting index for the current page
    end_index = start_index + BOOKS_PER_PAGE - 1         # Calculate the ending index for the current page
    @visible_favourites = []                            # Initialize the array to hold visible books
    i = start_index
    while i <= end_index && i < @book_collection.favourites.size
      @visible_favourites << @book_collection.favourites[i]  # Add the book to the visible favourites
      i += 1
    end
    @total_pages = calculate_total_pages                 # Recalculate total pages in case of changes
  end

  # Update hover states for buttons based on current mouse position
  def update(mouse_x, mouse_y, button_down)
    # Update hover state for the close button
    @close_button.hovered = @close_button.is_mouse_over?(mouse_x, mouse_y)
    # Update hover states for pagination buttons if they exist
    if @total_pages > 1
      if @prev_button
        @prev_button.hovered = @prev_button.is_mouse_over?(mouse_x, mouse_y)
      end
      if @next_button
        @next_button.hovered = @next_button.is_mouse_over?(mouse_x, mouse_y)
      end
    end
  end

  # Draw the favourites view with books in a grid layout
  def draw
    # Draw a semi-transparent overlay to dim the background
    Gosu.draw_rect(0, 0, @window.width, @window.height, TRANSPARENT_LIGHT_GRAY, ZOrder::OVERLAY)

    # Define the position and size of the favourites box
    box_x = 100
    box_y = 50
    box_width = @window.width - 200
    box_height = @window.height - 100
    # Draw the favourites box with a semi-transparent dark gray background
    Gosu.draw_rect(box_x, box_y, box_width, box_height, TRANSPARENT_DARK_GRAY, ZOrder::OVERLAY)

    # Draw the title for the favourites section
    @font.draw_text("Your Favourite Books:", box_x + 500, box_y + 20, ZOrder::OVERLAY_TEXT, 2.0, 2.0, Gosu::Color::WHITE)

    # Define grid layout parameters for displaying books
    base_x = box_x + 150
    base_y = box_y + 70
    spacing_x = 300       # Horizontal spacing between books
    spacing_y = 450       # Vertical spacing between books
    book_cover_width = 200
    book_cover_height = 300

    # Iterate through visible favourites and draw them using a while loop
    index = 0 
    while index < @visible_favourites.size
      book = @visible_favourites[index]

      # Calculate the row and column for the current book
      row = (index / COLUMNS)
      col = (index % COLUMNS)
      x = base_x + col * spacing_x             # Calculate x-position based on column
      y = base_y + row * spacing_y             # Calculate y-position based on row

      # Draw a drop shadow for the book cover to create a 3D effect
      Gosu.draw_rect(x + 5, y + 5, book_cover_width, book_cover_height, Gosu::Color::BLACK, ZOrder::OVERLAY)

      # Draw the book cover image if it exists
      if File.exist?(book.cover_image_path)
        cover = Gosu::Image.new(book.cover_image_path) 
        cover.draw(x, y, ZOrder::OVERLAY, book_cover_width.to_f / cover.width, book_cover_height.to_f / cover.height)  # Scale the cover image to fit
      else
        # If cover image is missing, draw a placeholder rectangle
        Gosu.draw_rect(x, y, book_cover_width, book_cover_height, LIGHT_GRAY, ZOrder::OVERLAY)
      end

      # Draw the book's title below the cover with word wrapping
      @window.draw_text_wrapped(@font, book.title, x, y + book_cover_height + 5, book_cover_width, Gosu::Color::BLACK, ZOrder::TEXT, 1.2, 1.2)

      # Draw the user's rating stars below the title
      draw_user_rating_stars(x, y + book_cover_height + 75, book.user_rating)
      
      index += 1
    end 

    # Draw pagination controls if there is more than one page
    if @total_pages > 1
      # Display the current page number and total pages
      pagination_text = "Page #{@current_page} of #{@total_pages}"
      @font.draw_text(
        pagination_text,
        (box_x + box_width / 2) - (@font.text_width(pagination_text) / 2),
        box_y + box_height - 30,
        ZOrder::OVERLAY_TEXT,
        1.0, 1.0,
        Gosu::Color::WHITE
      )

      # Draw Previous and Next buttons for pagination
      @prev_button.draw
      @next_button.draw
    end 

    # Draw the close button to exit the favourites view
    @close_button.draw
  end

  # Handle click events within the favourites view
  def handle_click(mouse_x, mouse_y)
    # Check if the close button was clicked
    if @close_button.hovered
      @window.toggle_favourites        # Toggle the favourites view off
      return
    end

    # Check if pagination buttons were clicked
    if @total_pages > 1
      if @prev_button && @prev_button.hovered
        previous_page                   # Navigate to the previous page
        return
      elsif @next_button && @next_button.hovered
        next_page                       # Navigate to the next page
        return
      end
    end

    # Iterate through visible favourites to check if any book was clicked
    index = 0
    while index < @visible_favourites.size
      book = @visible_favourites[index]
      row = (index / COLUMNS)
      col = (index % COLUMNS)
      x = 250 + col * 300                   # Calculate x-position for the book cover
      y = 120 + row * 450                   # Calculate y-position for the book cover

      # Check if the mouse is over the current book's cover area
      if @window.mouse_over?(mouse_x, mouse_y, x, y, 200, 300)
        @window.toggle_favourites           # Close the favourites view
        @window.display_book_details(book)   # Open the detailed view for the clicked book
        return
      end
      
      index += 1
    end
  end

  # Update the list of visible favourites based on the current page
  def update_visible_favourites
    start_index = (@current_page - 1) * BOOKS_PER_PAGE  # Calculate the starting index
    end_index = start_index + BOOKS_PER_PAGE - 1         # Calculate the ending index
    @visible_favourites = []                            # Initialize the array for visible favourites
    i = start_index
    while i <= end_index && i < @book_collection.favourites.size
      @visible_favourites << @book_collection.favourites[i]  # Add the book to the visible favourites
      i += 1
    end
    @total_pages = (@book_collection.favourites.size / BOOKS_PER_PAGE.to_f).ceil  # Recalculate total pages
  end

  # Navigate to the next page in the favourites view
  def next_page
    if @current_page < @total_pages
      @current_page += 1                    # Increment the current page number
      update_visible_favourites             # Update the visible favourites for the new page
    end
  end

  # Navigate to the previous page in the favourites view
  def previous_page
    if @current_page > 1
      @current_page -= 1                    # Decrement the current page number
      update_visible_favourites             # Update the visible favourites for the new page
    end
  end

  # Helper method to draw wrapped text by delegating to the main window's method
  def draw_text_wrapped(font, text, x, y, max_width, color, z_order, scale_x, scale_y)
    @window.draw_text_wrapped(font, text, x, y, max_width, color, z_order, scale_x, scale_y)
  end

  # Draw user rating stars based on the user_rating
  def draw_user_rating_stars(x, y, rating)
    full_stars = rating.to_f.floor                # Number of full stars
    if (rating.to_f - full_stars) >= 0.5
      half_star = 1                                # Include a half star if applicable
    else
      half_star = 0
    end
    empty_stars = 5 - full_stars - half_star      # Remaining stars are empty

    i = 0
    # Draw full stars
    while i < full_stars
      @star_full.draw(x + i * 25, y, ZOrder::OVERLAY_TEXT, 0.5, 0.5)
      i +=1
    end 
    # Draw half star if applicable
    if half_star ==1
      @star_half.draw(x + i * 25, y, ZOrder::OVERLAY_TEXT, 0.5, 0.5)
      i +=1
    end 
    # Draw empty stars
    while i < 5
      @star_empty.draw(x + i * 25, y, ZOrder::OVERLAY_TEXT, 0.5, 0.5)
      i += 1
    end
    # Draw the numeric rating next to the stars
    @font.draw_text(rating, x + 150, y + 12, ZOrder::OVERLAY_TEXT, 1.25, 1.25, Gosu::Color::BLACK)
  end
end

# Main BookBuddy Window
class BookBuddyMain < Gosu::Window
  BOOKS_PER_PAGE = 10                       # Number of books to display per page in the main view
  ROWS = 2                                  # Number of rows in the main book grid
  COLUMNS = 5                               # Number of columns in the main book grid

  # Define getter and setter methods for BookBuddyMain attributes
  attr_accessor :book_collection

  # Initialize the main window and its components
  def initialize
    super 1600, 1300, true                    # Set window size to 1600x1300 and make it fullscreen
    self.caption = "Book Buddy"                # Set the window title

    @book_collection = BookCollection.new     # Create a new BookCollection instance
    @file_name = 'books.csv'                  # CSV file containing all books
    @favourites_file = 'favourites.csv'       # CSV file containing favourite books
    @book_collection.load_books(@file_name)   # Load books from the CSV file
    @book_collection.favourites = load_favourites(@favourites_file)  # Load favourites from CSV

    # Initialize fonts for rendering text
    @font = Gosu::Font.new(24)                 # Larger font for main text
    @small_font = Gosu::Font.new(18)           # Smaller font for subtitles and labels

    # Load images required for the UI
    @background_gradient = Gosu::Image.new("assets/backgrounds/background_gradient.png")  # Background image

    # Load star images for ratings
    @star_full = Gosu::Image.new("assets/buttons/star_full.png")    # Full star image
    @star_empty = Gosu::Image.new("assets/buttons/star_empty.png")  # Empty star image
    @star_half = Gosu::Image.new("assets/buttons/star_half.png")    # Half star image

    # Load UI Button Images
    @mute_icon = Gosu::Image.new("assets/buttons/mute.png")         # Mute icon for toggling music

    @song = Gosu::Song.new("assets/sounds/Background_music.wav")    # Background music song
    toggle_song                                                    # Start playing or pause the song based on current state

    # Load owl character with animation frames and tooltips
    owl_image_paths = [
      "assets/owl/owl_idle.png",
      "assets/owl/owl_blink1.png",
    ]
    owl_tooltips = [
      "I'm your helpful book buddy, here to assist you with your book library",
      "Mark books as favourites for easy access.",
      "Navigate through pages using Next and Previous buttons.",
      "Explore your favourite books in the Favourites section.",
      "Click the desired genre button at the top of the screen to display only books of that genre.",
      "If the music is too loud press the mute button to the bottom right",
      "Click on a book cover to view detailed information about the book"
    ]
    @owl = OwlCharacter.new(300, 970, owl_image_paths, owl_tooltips, self)  # Initialize the OwlCharacter

    # Pagination setup for the main book view
    @current_page = 1                                      # Start at the first page
    @selected_genre = Genre::ALL_GENRES                     # Initially, all genres are selected
    @filtered_books = @book_collection.books.clone          # Clone all books for filtering
    @total_pages = (@filtered_books.size / BOOKS_PER_PAGE.to_f).ceil  # Calculate total pages

    # Initialize all buttons and store them in an array for easy management
    @buttons = []
    initialize_pagination_buttons                          # Add pagination buttons to @buttons
    initialize_genre_buttons                               # Add genre buttons to @buttons

    # Define book cover dimensions and margins for layout
    @book_cover_width = 200
    @book_cover_height = 300
    @book_margin_x = 100
    @book_margin_y = 150

    # Detailed view setup (initially not active)
    @detailed_view = nil

    # Favourites view setup (initially not active)
    @favourites_view = nil
    @show_favourites = false

    # Define grid layout parameters for the main book grid
    @grid_base_x = 100
    @grid_base_y = 100
    @grid_spacing_x = @book_cover_width + @book_margin_x  # Horizontal spacing between books
    @grid_spacing_y = @book_cover_height + @book_margin_y # Vertical spacing between books

    # Prepare visible books for the current page
    update_visible_books
  end

  # Toggle playing or pausing the background music
  def toggle_song
    if @song.playing?
      @song.pause                              # Pause the song if it's currently playing
    else
      @song.play(false)                        # Play the song; 'false' means it won't loop
    end
  end

  # Initialize Pagination Buttons and add them to the @buttons array
  def initialize_pagination_buttons
    @buttons << Button.new(
      1300, 1200, 100, 50, "Next", "next",
      @font, LIGHT_GRAY, LIGHT_GRAY, ZOrder::BUTTON
    )  # Next page button
    @buttons << Button.new(
      1200, 1200, 100, 50, "Previous", "previous",
      @font, LIGHT_GRAY, LIGHT_GRAY, ZOrder::BUTTON
    )  # Previous page button
    @buttons << Button.new(
      100, 1200, 150, 50, "Favourites", "favourites",
      @font, LIGHT_GRAY, LIGHT_GRAY, ZOrder::BUTTON
    )  # Favourites view toggle button
    @buttons << Button.new(
      1150, 1200, 50, 50, "", "mute",
      @font, LIGHT_GRAY, LIGHT_GRAY, ZOrder::BUTTON
    )  # Mute button with no text (icon-based)
  end

  # Initialize Genre Buttons in a Single Horizontal Row with a Single Hover Color (Yellow)
  def initialize_genre_buttons
    genre_button_height = 40                # Height of genre buttons
    genre_button_padding_x = 10             # Horizontal padding between genre buttons
    genre_x_start = 30                      # Starting x-position for the first genre button
    genre_y_start = 20                      # y-position for genre buttons
    genre_button_width_default = 120        # Default width for genre buttons

    current_x = genre_x_start               # Initialize current x-position for placing buttons

    index = 0
    while index < Genre::ALL_GENRES.size
      genre = Genre::ALL_GENRES[index]

      # Determine button width based on genre name length for better UI fit
      if genre == "Science Fiction"
        genre_button_width = 180
      elsif genre == "Non-Fiction"
        genre_button_width = 160
      else
        genre_button_width = 120
      end

      hover_color = Gosu::Color::YELLOW      # Assign a uniform hover color (yellow) for all genre buttons

      # Create and add the genre button to the @buttons array
      @buttons << Button.new(
        current_x, genre_y_start, genre_button_width, genre_button_height,
        genre, "genre_#{genre.downcase.gsub(' ', '_')}", # Set button ID to lowercase genre name with underscores
        @font, Gosu::Color::WHITE, hover_color, ZOrder::BUTTON
      )

      # Update current_x for the next button's position
      current_x += genre_button_width + genre_button_padding_x

      index += 1  # Move to the next genre
    end
  end

  # Draw genre buttons by iterating through all genres and matching them with buttons
  def draw_genre_buttons
    genre_index = 0  # Initialize the index for genres
  
    # Iterate through all genres using a while loop
    while genre_index < Genre::ALL_GENRES.size
      genre = Genre::ALL_GENRES[genre_index]
      
      # Construct the expected button ID for the current genre
      expected_id = "genre_#{genre.downcase.gsub(' ', '_')}"  # IDs are in the format "genre_science_fiction"
      
      button_found = false  # Flag to indicate if the button is found
      button_index = 0       # Initialize the index for buttons
  
      # Iterate through all buttons using a while loop
      while button_index < @buttons.size && !button_found
        button = @buttons[button_index]
        
        if button.id == expected_id
          button.draw             # Draw the button if it matches the current genre
          button_found = true     # Set flag to true to exit the inner loop
        end
        
        button_index += 1          # Move to the next button
      end
  
      genre_index += 1              # Move to the next genre
    end
  end

  # Helper method to draw wrapped text by delegating to the main window's method
  def draw_text_wrapped(font, text, x, y, max_width, color, z_order, scale_x, scale_y)
    words = text.split(' ')            # Split the text into individual words
    lines = []                         # Array to hold each line of wrapped text
    current_line = ''                  # Initialize the current line as empty

    i = 0
    while i < words.size
      word = words[i]

      if current_line.empty?            # If the current_line is empty, start with the current word
        test_line = word
      else
        test_line = "#{current_line} #{word}"  # Otherwise, try adding the current word to the existing line with a space
      end

      if font.text_width(test_line) > max_width    # Check if the width of the test_line exceeds the maximum allowed width
        lines << current_line                      # If it does, add the current_line to lines array
        current_line = word                        # Start a new line with the current word
      else
        current_line = test_line                   # If it doesn't exceed, update the current_line to include the new word
      end
      i += 1
    end
    
    if !(current_line.empty?)
      lines << current_line                         # After processing all words, add any remaining text in current_line to lines
    end 

    i = 0
    while i < lines.size
      line = lines[i]

      # Draw the current line of text on the screen at the specified position
      # y position is adjusted by the line number multiplied by the font's height to stack lines vertically
      font.draw_text(line, x, y + i * font.height, z_order, scale_x, scale_y, color)
      
      i += 1
    end
  end

  # Draw stars based on the rating (supports full, half, and empty stars)
  def draw_stars(x, y, rating)
    full_stars = rating.to_f.floor                # Number of full stars
    if (rating.to_f - full_stars) >= 0.5
      half_star = 1                                # Include a half star if applicable
    else
      half_star = 0
    end
    empty_stars = 5 - full_stars - half_star      # Remaining stars are empty

    i = 0
    # Draw full stars
    while i < full_stars
      @star_full.draw(x + i * 25, y, ZOrder::TEXT, 0.5, 0.5)
      i += 1
    end
    # Draw half star if applicable
    if half_star == 1
      @star_half.draw(x + i * 25, y, ZOrder::TEXT, 0.5, 0.5)
      i += 1
    end
    # Draw empty stars
    while i < 5
      @star_empty.draw(x + i * 25, y, ZOrder::TEXT, 0.5, 0.5)
      i += 1
    end
    # Draw the numeric rating next to the stars
    @font.draw_text(rating, x + 150, y + 12, ZOrder::TEXT, 1.25, 1.25, Gosu::Color::BLACK)
  end

  # Load favourite books from CSV
  def load_favourites(file_name)
    favourites = []                             # Initialize an array to hold favourite books
    if File.exist?(file_name)                   # Check if the favourites file exists
      file = File.open(file_name, 'r')          # Open the CSV file in read mode
      headers = file.gets                        # Read the header line

      while (row = file.gets)                    # Iterate through each subsequent line in the file
        data = CSV.parse_line(row)               # Parse the CSV line into an array of fields

        awards = []
        if data[5] && !data[5].empty?             # Check if the awards field exists and is not empty
          awards = data[5].split(';')             # Split awards by semicolon into an array
        end

        # Ensure the row has enough columns to prevent errors
        if data && data.size >= 12
          # Create a new Book object with the parsed data
          book = Book.new(
            data[0], # Title
            data[1], # Author
            data[2], # Genre
            data[3], # Publication Date
            data[4], # Blurb
            awards,
            data[6], # Publishing House
            data[7], # Nationality
            data[8], # Cover Image Path
            data[9], # Author Photo Path
            data[10].to_f, # Average Rating converted to float
            data[11].to_f  # User Rating converted to float
          )
          favourites << book                        # Add the book to the favourites array
        end
      end

      file.close                                  # Close the file after reading
      puts "#{favourites.size} favourite books loaded from #{file_name}."  # Output the number of favourites loaded
    end
    return favourites                              # Return the array of favourite books
  end

  # Save favourite books to CSV by delegating to the BookCollection's method
  def save_favourites
    @book_collection.save_favourites(@favourites_file)
  end

  # Update method called every frame to update game logic
  def update
    @owl.update                                     # Update the owl's animation and tooltips

    if !(@show_favourites)                          # If the favourites view is not active
      mouse_x_pos, mouse_y_pos = mouse_x, mouse_y    # Get current mouse position

      # Update hover states for all buttons using a while loop
      index = 0
      while index < @buttons.size
        button = @buttons[index]
        button.is_mouse_over?(mouse_x_pos, mouse_y_pos)  # Update hover state based on mouse position
        index += 1
      end
    end 

    # Update the detailed view if it is active
    if @detailed_view
      mouse_x_pos, mouse_y_pos = mouse_x, mouse_y
      @detailed_view.update(mouse_x_pos, mouse_y_pos, button_down?(Gosu::MsLeft))
    end

    # Update the favourites view if it is active
    if @favourites_view
      mouse_x_pos, mouse_y_pos = mouse_x, mouse_y
      @favourites_view.update(mouse_x_pos, mouse_y_pos, button_down?(Gosu::MsLeft))
    end
  end

  # Draw method called every frame to render graphics
  def draw
    # Draw background gradient if the image exists, else draw a solid black background
    if @background_gradient
      @background_gradient.draw(0, 0, ZOrder::BACKGROUND, width.to_f / @background_gradient.width, height.to_f / @background_gradient.height)
    else
      Gosu.draw_rect(0, 0, width, height, Gosu::Color::BLACK, ZOrder::BACKGROUND)
    end

    if !(@show_favourites)                        # If the favourites view is not active
      # Draw books in fixed positions using a while loop
      i = 0
      while i < @visible_books.size
        book = @visible_books[i]
        row = i / COLUMNS
        col = i % COLUMNS
        x = @grid_base_x + col * @grid_spacing_x    # Calculate x-position based on column
        y = @grid_base_y + row * @grid_spacing_y    # Calculate y-position based on row

        # Draw a drop shadow for the book cover to create a 3D effect
        Gosu.draw_rect(x + 5, y + 5, @book_cover_width, @book_cover_height, Gosu::Color::BLACK, ZOrder::BOOK)

        # Draw the book cover image if it exists
        if File.exist?(book.cover_image_path)
          cover = Gosu::Image.new(book.cover_image_path)
          if cover
            # Draw the cover image scaled to fit the defined dimensions
            cover.draw(x, y, ZOrder::BOOK, @book_cover_width.to_f / cover.width, @book_cover_height.to_f / cover.height)
          else
            # If the cover image failed to load, display "No Cover" text centered in the placeholder
            draw_text_wrapped(@small_font, "No Cover", x, y + (@book_cover_height / 2) - (@small_font.height / 2), @book_cover_width, Gosu::Color::WHITE, ZOrder::BOOK, 1.0, 1.0)
          end
        else
          # If cover image is missing, draw a placeholder rectangle
          Gosu.draw_rect(x, y, @book_cover_width, @book_cover_height, LIGHT_GRAY, ZOrder::BOOK)
        end

        # Draw the book's title below the cover with word wrapping
        draw_text_wrapped(@font, book.title, x, y + @book_cover_height + 5, @book_cover_width, Gosu::Color::BLACK, ZOrder::TEXT, 1.2, 1.2)

        # Draw the average rating stars below the title
        draw_stars(x, y + @book_cover_height + 75, book.average_rating)

        i += 1
      end

      # Draw all buttons using a while loop
      i = 0
      while i < @buttons.size
        @buttons[i].draw
        i += 1
      end

      # Draw the page indicator at the bottom center of the window
      page_text = "Page #{@current_page} of #{@total_pages}"
      @font.draw_text(page_text, (width - @font.text_width(page_text)) / 2, 1250, ZOrder::TEXT, 1.0, 1.0, Gosu::Color::BLACK)

      # Draw genre buttons by delegating to the draw_genre_buttons method
      draw_genre_buttons

      # Draw the mute icon on the mute button
      @mute_icon.draw(1150, 1200, ZOrder::BUTTON, 0.5, 0.5)
    end

    # Draw the detailed view if it is active
    if @detailed_view
      @detailed_view.draw
    end

    # Draw the favourites view if it is active
    if @favourites_view
      @favourites_view.draw 
    end

    # Draw the owl character
    @owl.draw
  end

  # Handle button and mouse click events
  def button_down(id)
    case id
    when Gosu::MsLeft                           # When the left mouse button is clicked
      mouse_x_pos, mouse_y_pos = mouse_x, mouse_y

      if @show_favourites
        @favourites_view.handle_click(mouse_x_pos, mouse_y_pos)  # Delegate click handling to favourites view
        return
      end

      if @detailed_view
        @detailed_view.handle_click(mouse_x_pos, mouse_y_pos)    # Delegate click handling to detailed view
        return
      end

      # Iterate through all buttons to determine which one was clicked using a while loop
      clicked_button = nil
      index = 0
      buttons_length = @buttons.size

      while index < buttons_length
        button = @buttons[index]
        if button.hovered
          clicked_button = button               # Assign the clicked button
          break                                 # Exit the loop once the hovered button is found
        end
        index += 1
      end

      # Proceed if a clicked_button was found
      if clicked_button
        if clicked_button.id == "next"
          next_page                             # Navigate to the next page
        elsif clicked_button.id == "previous"
          previous_page                         # Navigate to the previous page
        elsif clicked_button.id == "favourites"
          toggle_favourites                     # Toggle the favourites view
        elsif clicked_button.id == "mute"
          toggle_song                           # Toggle the background music
        elsif clicked_button.id =~ /^genre_(.*)$/  # Check if clicked button ID starts with "genre_"
          # If matched, $1 contains the genre name part after "genre_"
          selected_genre = $1.gsub('_', ' ').split.map(&:capitalize).join(' ')  
          # Replace underscores with spaces, split into words, capitalize each word, and join back
          apply_genre_filter(selected_genre)      # Apply the genre filter based on the selected genre
        end
        return                                    # Exit after handling the button click
      end

      # Check if a book is clicked by iterating through visible books
      index = 0
      while index < @visible_books.size
        book = @visible_books[index]
        row = (index / COLUMNS)
        col = (index % COLUMNS)
        x = @grid_base_x + col * @grid_spacing_x
        y = @grid_base_y + row * @grid_spacing_y
      
        # Check if the mouse is over the current book's cover area
        if mouse_over?(mouse_x_pos, mouse_y_pos, x, y, @book_cover_width, @book_cover_height)
          display_book_details(book)               # Open the detailed view for the clicked book
          break
        end
        index += 1
      end

      # Check if the owl character was clicked
      owl_image = @owl.images[0]
      owl_width = owl_image.width
      owl_height = owl_image.height
      if mouse_over?(mouse_x_pos, mouse_y_pos, @owl.x, @owl.y, owl_width, owl_height)
        interact_with_owl                        # Trigger interaction with the owl
      end

    when Gosu::KbEscape                          # When the Escape key is pressed
      save_favourites                            # Save the current favourites list
      close                                      # Close the application window
    end
  end

  # Apply the genre filter to display only books of the selected genre
  def apply_genre_filter(selected_genre)
    @selected_genre = selected_genre            # Update the selected genre
    if selected_genre == Genre::ALL
      @filtered_books = @book_collection.books.clone   # If "All" is selected, show all books
    else
      @filtered_books = []                          # Otherwise, filter books by genre
      i = 0
      while i < @book_collection.books.size
        book_genre = @book_collection.books[i].genre
        if book_genre.downcase == selected_genre.downcase  # Compare genres case-insensitively
          @filtered_books << @book_collection.books[i]    # Add matching book to filtered_books
        end
        i += 1
      end
    end
    @current_page = 1                                 # Reset to the first page after filtering
    @total_pages = (@filtered_books.size / BOOKS_PER_PAGE.to_f).ceil  # Recalculate total pages
    update_visible_books                              # Update the list of visible books based on the new filter
  end

  # Update the list of visible books based on the current page
  def update_visible_books
    start_index = (@current_page - 1) * BOOKS_PER_PAGE  # Calculate the starting index for the current page
    end_index = start_index + BOOKS_PER_PAGE - 1         # Calculate the ending index for the current page
    @visible_books = []                                  # Initialize the array to hold visible books
    i = start_index
    while i <= end_index && i < @filtered_books.size
      @visible_books << @filtered_books[i]              # Add the book to the visible books array
      i += 1
    end
    @total_pages = (@filtered_books.size / BOOKS_PER_PAGE.to_f).ceil  # Recalculate total pages
  end

  # Check if the mouse is over a specific area (rectangle)
  def mouse_over?(mx, my, x, y, width, height)
    return mx >= x && mx <= x + width && my >= y && my <= y + height  # Return true if mouse is within the rectangle
  end

  # Toggle the favourites view on or off
  def toggle_favourites
    if @show_favourites
      @show_favourites = false                        # Hide the favourites view
      @favourites_view = nil                           # Clear the favourites view instance
    else
      @show_favourites = true                         # Show the favourites view
      @favourites_view = FavouritesView.new(
        self, @book_collection, @font, @small_font, @star_full, @star_empty, @star_half
      )  # Initialize a new FavouritesView
    end
  end

  # Display the detailed view for a selected book
  def display_book_details(book)
    if @detailed_view
      close_detailed_view                             # Close any existing detailed view
    end
    @detailed_view = DetailedView.new(
      book,
      self,
      @font,
      @small_font,
      @star_full,
      @star_empty,
      @star_half
    )  # Initialize a new DetailedView for the selected book
  end

  # Close the detailed view
  def close_detailed_view
    @detailed_view = nil                               # Clear the detailed view instance
  end

  # Handle rating submission from the detailed view
  def rate_book(book, rating)
    book.user_rating = rating.to_f                      # Update the book's user rating
    if !@book_collection.favourite?(book)
      @book_collection.favourites << book              # Add the book to favourites if not already present
    end
    puts "You rated '#{book.title}' with #{rating} stars."  # Output confirmation
    @detailed_view = nil                                 # Close the detailed view after rating
  end

  # Navigate to the next page in the main book view
  def next_page
    if @current_page < @total_pages
      @current_page += 1                            # Increment the current page number
      update_visible_books                           # Update the list of visible books for the new page
    end
  end

  # Navigate to the previous page in the main book view
  def previous_page
    if @current_page > 1
      @current_page -= 1                            # Decrement the current page number
      update_visible_books                           # Update the list of visible books for the new page
    end
  end

  # Handle the owl character interaction (e.g., displaying a tip)
  def interact_with_owl
    tip = "Welcome to Book Buddy! Explore books and find your next read."  # Define the tooltip text
    @owl.tooltip = tip                                             # Set the owl's tooltip
    @owl.tooltip_timer = Gosu.milliseconds                        # Reset the tooltip timer
  end
end

# Run the application by creating a new instance of BookBuddyMain and showing the window
BookBuddyMain.new.show if __FILE__ == $0

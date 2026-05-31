package model;

/**
 * MODEL CLASS: Book
 * Encapsulates book data members with getters/setters.
 * Represents a row from the `books` table.
 */
public class Book {

    // -------------------------------------------------------
    // Data Members (Private - Encapsulation)
    // -------------------------------------------------------
    private int    bookId;
    private String bookName;
    private String authorName;
    private String availabilityStatus;

    // -------------------------------------------------------
    // Constructors
    // -------------------------------------------------------

    /** Default constructor */
    public Book() {}

    /** Parameterized constructor */
    public Book(int bookId, String bookName, String authorName, String availabilityStatus) {
        this.bookId             = bookId;
        this.bookName           = bookName;
        this.authorName         = authorName;
        this.availabilityStatus = availabilityStatus;
    }

    // -------------------------------------------------------
    // Member Functions
    // -------------------------------------------------------

    /**
     * Placeholder: add book to library (logic delegated to DAO).
     */
    public String addBook() {
        return "Book '" + bookName + "' by " + authorName + " added to library.";
    }

    /**
     * Placeholder: remove book from library (logic delegated to DAO).
     */
    public String removeBook() {
        return "Book ID " + bookId + " removed from library.";
    }

    // -------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------
    public int    getBookId()                       { return bookId; }
    public void   setBookId(int bookId)             { this.bookId = bookId; }

    public String getBookName()                     { return bookName; }
    public void   setBookName(String bookName)      { this.bookName = bookName; }

    public String getAuthorName()                       { return authorName; }
    public void   setAuthorName(String authorName)      { this.authorName = authorName; }

    public String getAvailabilityStatus()                           { return availabilityStatus; }
    public void   setAvailabilityStatus(String availabilityStatus)  { this.availabilityStatus = availabilityStatus; }
}

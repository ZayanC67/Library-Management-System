package model;

import java.util.Date;

/**
 * MODEL CLASS: BookReturn
 * Encapsulates book return transaction data.
 * Represents a row from the `book_return` table.
 */
public class BookReturn {

    // -------------------------------------------------------
    // Data Members (Private - Encapsulation)
    // -------------------------------------------------------
    private int    returnId;
    private int    bookId;
    private Date   returnDate;
    private String studentId; // USN

    // extra fields for display (joined queries)
    private String bookName;
    private String studentName;

    // -------------------------------------------------------
    // Constructors
    // -------------------------------------------------------

    /** Default constructor */
    public BookReturn() {}

    /** Parameterized constructor */
    public BookReturn(int returnId, int bookId, Date returnDate, String studentId) {
        this.returnId   = returnId;
        this.bookId     = bookId;
        this.returnDate = returnDate;
        this.studentId  = studentId;
    }

    // -------------------------------------------------------
    // Member Functions
    // -------------------------------------------------------

    /**
     * Placeholder: return book (logic delegated to DAO).
     */
    public String returnBook() {
        return "Book ID " + bookId + " returned by USN: " + studentId
             + " on " + returnDate;
    }

    // -------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------
    public int    getReturnId()                     { return returnId; }
    public void   setReturnId(int returnId)         { this.returnId = returnId; }

    public int    getBookId()                       { return bookId; }
    public void   setBookId(int bookId)             { this.bookId = bookId; }

    public Date   getReturnDate()                   { return returnDate; }
    public void   setReturnDate(Date returnDate)    { this.returnDate = returnDate; }

    public String getStudentId()                    { return studentId; }
    public void   setStudentId(String studentId)    { this.studentId = studentId; }

    public String getBookName()                     { return bookName; }
    public void   setBookName(String bookName)      { this.bookName = bookName; }

    public String getStudentName()                      { return studentName; }
    public void   setStudentName(String studentName)    { this.studentName = studentName; }
}

package model;

import java.util.Date;

/**
 * MODEL CLASS: BookIssue
 * Encapsulates book issue transaction data.
 * Represents a row from the `book_issue` table.
 */
public class BookIssue {

    // -------------------------------------------------------
    // Data Members (Private - Encapsulation)
    // -------------------------------------------------------
    private int    issueId;
    private int    bookId;
    private Date   issueDate;
    private String studentId;  // USN

    // book and student name (for display joins)
    private String bookName;
    private String studentName;

    // -------------------------------------------------------
    // Constructors
    // -------------------------------------------------------

    /** Default constructor */
    public BookIssue() {}

    /** Parameterized constructor */
    public BookIssue(int issueId, int bookId, Date issueDate, String studentId) {
        this.issueId   = issueId;
        this.bookId    = bookId;
        this.issueDate = issueDate;
        this.studentId = studentId;
    }

    // -------------------------------------------------------
    // Member Functions
    // -------------------------------------------------------

    /**
     * Placeholder: issue book (logic delegated to DAO).
     */
    public String issue() {
        return "Book ID " + bookId + " issued to USN: " + studentId
             + " on " + issueDate;
    }

    // -------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------
    public int    getIssueId()                  { return issueId; }
    public void   setIssueId(int issueId)       { this.issueId = issueId; }

    public int    getBookId()                   { return bookId; }
    public void   setBookId(int bookId)         { this.bookId = bookId; }

    public Date   getIssueDate()                { return issueDate; }
    public void   setIssueDate(Date issueDate)  { this.issueDate = issueDate; }

    public String getStudentId()                    { return studentId; }
    public void   setStudentId(String studentId)    { this.studentId = studentId; }

    public String getBookName()                 { return bookName; }
    public void   setBookName(String bookName)  { this.bookName = bookName; }

    public String getStudentName()                      { return studentName; }
    public void   setStudentName(String studentName)    { this.studentName = studentName; }
}

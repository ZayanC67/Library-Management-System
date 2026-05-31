package model;

import java.util.Date;

/**
 * MODEL CLASS: BookRequest
 * Represents a student book request record.
 */
public class BookRequest {

    private int    requestId;
    private int    bookId;
    private Date   requestDate;
    private String usn;
    private String status;
    private String librarianComment;

    private String bookName;
    private String studentName;
    private String authorName;

    public BookRequest() {}

    public BookRequest(int requestId, int bookId, Date requestDate, String usn, String status, String librarianComment) {
        this.requestId = requestId;
        this.bookId = bookId;
        this.requestDate = requestDate;
        this.usn = usn;
        this.status = status;
        this.librarianComment = librarianComment;
    }

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public Date getRequestDate() { return requestDate; }
    public void setRequestDate(Date requestDate) { this.requestDate = requestDate; }

    public String getUsn() { return usn; }
    public void setUsn(String usn) { this.usn = usn; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getLibrarianComment() { return librarianComment; }
    public void setLibrarianComment(String librarianComment) { this.librarianComment = librarianComment; }

    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
}

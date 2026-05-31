package model;

/**
 * MODEL CLASS: Librarian
 * Encapsulates librarian data members with getters/setters.
 * Represents a row from the `librarian` table.
 */
public class Librarian {

    // -------------------------------------------------------
    // Data Members (Private - Encapsulation)
    // -------------------------------------------------------
    private int    librarianId;
    private String librarianName;
    private String username;
    private String password;

    // -------------------------------------------------------
    // Constructors
    // -------------------------------------------------------

    /** Default constructor */
    public Librarian() {}

    /** Parameterized constructor */
    public Librarian(int librarianId, String librarianName,
                     String username, String password) {
        this.librarianId   = librarianId;
        this.librarianName = librarianName;
        this.username      = username;
        this.password      = password;
    }

    // -------------------------------------------------------
    // Member Functions
    // -------------------------------------------------------

    /** Placeholder: add a book */
    public String addBook(String bookName) {
        return librarianName + " is adding book: " + bookName;
    }

    /** Placeholder: remove a book */
    public String removeBook(int bookId) {
        return librarianName + " is removing book ID: " + bookId;
    }

    /** Placeholder: search a book */
    public String searchBook(String keyword) {
        return librarianName + " is searching for: " + keyword;
    }

    /** Placeholder: issue a book */
    public String issueBook(int bookId, String usn) {
        return librarianName + " issued book ID " + bookId + " to USN: " + usn;
    }

    /** Placeholder: receive a returned book */
    public String receiveBook(int bookId, String usn) {
        return librarianName + " received book ID " + bookId + " from USN: " + usn;
    }

    // -------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------
    public int    getLibrarianId()                      { return librarianId; }
    public void   setLibrarianId(int librarianId)       { this.librarianId = librarianId; }

    public String getLibrarianName()                        { return librarianName; }
    public void   setLibrarianName(String librarianName)    { this.librarianName = librarianName; }

    public String getUsername()                 { return username; }
    public void   setUsername(String username)  { this.username = username; }

    public String getPassword()                 { return password; }
    public void   setPassword(String password)  { this.password = password; }
}

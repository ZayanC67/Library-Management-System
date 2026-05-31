package model;

/**
 * MODEL CLASS: Student
 * Encapsulates student data members with getters/setters (Encapsulation).
 * Represents a row from the `student` table.
 */
public class Student {

    // -------------------------------------------------------
    // Data Members (Private - Encapsulation)
    // -------------------------------------------------------
    private String usn;
    private String studentName;
    private int    semester;
    private String branch;
    private String phoneNo;
    private String password;

    // -------------------------------------------------------
    // Constructors
    // -------------------------------------------------------

    /** Default constructor */
    public Student() {}

    /** Parameterized constructor */
    public Student(String usn, String studentName, int semester,
                   String branch, String phoneNo, String password) {
        this.usn         = usn;
        this.studentName = studentName;
        this.semester    = semester;
        this.branch      = branch;
        this.phoneNo     = phoneNo;
        this.password    = password;
    }

    // -------------------------------------------------------
    // Member Functions
    // -------------------------------------------------------

    /**
     * Returns a formatted string with student information.
     */
    public String studentInfo() {
        return "USN: " + usn + " | Name: " + studentName
             + " | Semester: " + semester + " | Branch: " + branch
             + " | Phone: " + phoneNo;
    }

    /**
     * Placeholder: search for a book (logic delegated to DAO).
     */
    public String searchBook(String keyword) {
        return "Searching for book: " + keyword;
    }

    /**
     * Placeholder: initiate payment (logic delegated to DAO).
     */
    public String payment(double amount) {
        return "Payment of Rs. " + amount + " initiated for USN: " + usn;
    }

    /**
     * Placeholder: borrow book (logic delegated to DAO).
     */
    public String borrowBook(int bookId) {
        return "Book ID " + bookId + " borrowing request raised for USN: " + usn;
    }

    // -------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------
    public String getUsn()                  { return usn; }
    public void   setUsn(String usn)        { this.usn = usn; }

    public String getStudentName()                      { return studentName; }
    public void   setStudentName(String studentName)    { this.studentName = studentName; }

    public int    getSemester()             { return semester; }
    public void   setSemester(int semester) { this.semester = semester; }

    public String getBranch()               { return branch; }
    public void   setBranch(String branch)  { this.branch = branch; }

    public String getPhoneNo()              { return phoneNo; }
    public void   setPhoneNo(String phoneNo){ this.phoneNo = phoneNo; }

    public String getPassword()                 { return password; }
    public void   setPassword(String password)  { this.password = password; }
}

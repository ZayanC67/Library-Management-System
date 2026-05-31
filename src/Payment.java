package model;

import java.util.Date;

/**
 * MODEL CLASS: Payment
 * Encapsulates payment transaction data.
 * Represents a row from the `payment` table.
 */
public class Payment {

    // -------------------------------------------------------
    // Data Members (Private - Encapsulation)
    // -------------------------------------------------------
    private int    paymentId;
    private String paymentType;
    private Date   paymentDate;
    private double amount;
    private String usn;

    // extra field for display
    private String studentName;

    // -------------------------------------------------------
    // Constructors
    // -------------------------------------------------------

    /** Default constructor */
    public Payment() {}

    /** Parameterized constructor */
    public Payment(int paymentId, String paymentType,
                   Date paymentDate, double amount, String usn) {
        this.paymentId   = paymentId;
        this.paymentType = paymentType;
        this.paymentDate = paymentDate;
        this.amount      = amount;
        this.usn         = usn;
    }

    // -------------------------------------------------------
    // Member Functions
    // -------------------------------------------------------

    /**
     * Returns a formatted string with payment details.
     */
    public String paymentDetails() {
        return "Payment ID: " + paymentId
             + " | Type: " + paymentType
             + " | Date: " + paymentDate
             + " | Amount: Rs." + amount
             + " | USN: " + usn;
    }

    /** Backward-compatible getter used by JSPs. */
    public String getPaymentDetails() {
        return paymentDetails();
    }

    // -------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------
    public int    getPaymentId()                    { return paymentId; }
    public void   setPaymentId(int paymentId)       { this.paymentId = paymentId; }

    public String getPaymentType()                      { return paymentType; }
    public void   setPaymentType(String paymentType)    { this.paymentType = paymentType; }

    public Date   getPaymentDate()                      { return paymentDate; }
    public void   setPaymentDate(Date paymentDate)      { this.paymentDate = paymentDate; }

    public double getAmount()               { return amount; }
    public void   setAmount(double amount)  { this.amount = amount; }

    public String getUsn()              { return usn; }
    public void   setUsn(String usn)    { this.usn = usn; }

    public String getStudentName()                      { return studentName; }
    public void   setStudentName(String studentName)    { this.studentName = studentName; }
}

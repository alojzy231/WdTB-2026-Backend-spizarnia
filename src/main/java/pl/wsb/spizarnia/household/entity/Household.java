package pl.wsb.spizarnia.household.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embedded;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.LocalDate;

/** Gospodarstwo domowe: mieszkanie lub dom, którego spiżarnię śledzą domownicy. */
@Entity
@Table(name = "household")
public class Household {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false, length = 80)
    private String name;

    /** Kolumny street, city i postal_code trafiają do tabeli household. */
    @Embedded
    private Address address;

    @Column(name = "members_count", nullable = false)
    private Integer membersCount;

    @Column(name = "created_at", nullable = false)
    private LocalDate createdAt;

    protected Household() {
    }

    public Household(String name, Address address, Integer membersCount) {
        this.name = name;
        this.address = address;
        this.membersCount = membersCount;
        this.createdAt = LocalDate.now();
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public Address getAddress() {
        return address;
    }

    public Integer getMembersCount() {
        return membersCount;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }
}

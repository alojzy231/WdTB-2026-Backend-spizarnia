package pl.wsb.spizarnia.household.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import pl.wsb.spizarnia.account.domain.UserAccount;

import java.time.LocalDate;

/** Domownik: osoba mieszkająca w gospodarstwie, która korzysta z aplikacji przez swoje konto. */
@Entity
@Table(name = "household_member")
public class HouseholdMember {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** Jak domownicy się nazywają między sobą, np. „Kasia”. */
    @Column(name = "nickname", nullable = false, length = 40)
    private String nickname;

    @Column(name = "joined_at", nullable = false)
    private LocalDate joinedAt;

    /** Właściciel zarządza gospodarstwem: zaprasza domowników i ustawia progi zakupów. */
    @Column(name = "is_owner", nullable = false)
    private Boolean owner;

    /** Wiele osób mieszka w jednym gospodarstwie. */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "household_id", nullable = false)
    private Household household;

    /** Jedno konto to jeden domownik; unique pilnuje, żeby dwóch domowników nie miało tego samego konta. */
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_account_id", nullable = false, unique = true)
    private UserAccount account;

    protected HouseholdMember() {
    }

    public HouseholdMember(String nickname, Boolean owner, Household household, UserAccount account) {
        this.nickname = nickname;
        this.owner = owner;
        this.household = household;
        this.account = account;
        this.joinedAt = LocalDate.now();
    }

    public Long getId() {
        return id;
    }

    public String getNickname() {
        return nickname;
    }

    public LocalDate getJoinedAt() {
        return joinedAt;
    }

    public Boolean getOwner() {
        return owner;
    }

    public Household getHousehold() {
        return household;
    }

    public UserAccount getAccount() {
        return account;
    }
}

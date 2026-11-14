package pl.wsb.spizarnia.pantry.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import pl.wsb.spizarnia.household.entity.Household;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

/** Produkt w spiżarni: ile go jest, gdzie leży i do kiedy jest ważny. */
@Entity
@Table(name = "pantry_item")
public class PantryItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false, length = 80)
    private String name;

    @Column(name = "quantity", nullable = false, precision = 8, scale = 2)
    private BigDecimal quantity;

    @Enumerated(EnumType.STRING)
    @Column(name = "unit", nullable = false, length = 10)
    private Unit unit;

    @Enumerated(EnumType.STRING)
    @Column(name = "location", nullable = false, length = 20)
    private StorageLocation location;

    @Column(name = "expiry_date")
    private LocalDate expiryDate;

    /** Próg w tej samej jednostce co {@code unit}: poniżej niego produkt trafia na listę zakupów. */
    @Column(name = "min_quantity", precision = 8, scale = 2)
    private BigDecimal minQuantity;

    @Column(name = "opened")
    private Boolean opened;

    /** Każdy produkt należy do spiżarni jednego gospodarstwa. */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "household_id", nullable = false)
    private Household household;

    /** Wiele-do-wielu bez własnych danych: tabelę łączącą pantry_item_tag tworzy Hibernate. */
    @ManyToMany
    @JoinTable(name = "pantry_item_tag",
            joinColumns = @JoinColumn(name = "pantry_item_id"),
            inverseJoinColumns = @JoinColumn(name = "tag_id"))
    private Set<Tag> tags = new HashSet<>();

    protected PantryItem() {
    }

    public PantryItem(String name, BigDecimal quantity, Unit unit, StorageLocation location,
                      LocalDate expiryDate, BigDecimal minQuantity, Boolean opened, Household household) {
        this.name = name;
        this.quantity = quantity;
        this.unit = unit;
        this.location = location;
        this.expiryDate = expiryDate;
        this.minQuantity = minQuantity;
        this.opened = opened;
        this.household = household;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public BigDecimal getQuantity() {
        return quantity;
    }

    public Unit getUnit() {
        return unit;
    }

    public StorageLocation getLocation() {
        return location;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public BigDecimal getMinQuantity() {
        return minQuantity;
    }

    public Boolean getOpened() {
        return opened;
    }

    public Household getHousehold() {
        return household;
    }

    public Set<Tag> getTags() {
        return tags;
    }
}

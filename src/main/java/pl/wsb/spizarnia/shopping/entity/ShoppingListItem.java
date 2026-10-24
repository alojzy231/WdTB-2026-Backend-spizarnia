package pl.wsb.spizarnia.shopping.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import pl.wsb.spizarnia.pantry.entity.Unit;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** Pozycja na liście zakupów: co kupić, ile i czy już kupione. */
@Entity
@Table(name = "shopping_list_item")
public class ShoppingListItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "product_name", nullable = false, length = 80)
    private String productName;

    @Column(name = "quantity", nullable = false, precision = 8, scale = 2)
    private BigDecimal quantity;

    @Enumerated(EnumType.STRING)
    @Column(name = "unit", nullable = false, length = 10)
    private Unit unit;

    @Column(name = "estimated_price", precision = 8, scale = 2)
    private BigDecimal estimatedPrice;

    @Column(name = "purchased", nullable = false)
    private Boolean purchased;

    @Column(name = "added_at", nullable = false)
    private LocalDateTime addedAt;

    protected ShoppingListItem() {
    }

    public ShoppingListItem(String productName, BigDecimal quantity, Unit unit, BigDecimal estimatedPrice) {
        this.productName = productName;
        this.quantity = quantity;
        this.unit = unit;
        this.estimatedPrice = estimatedPrice;
        this.purchased = false;
        this.addedAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public String getProductName() {
        return productName;
    }

    public BigDecimal getQuantity() {
        return quantity;
    }

    public Unit getUnit() {
        return unit;
    }

    public BigDecimal getEstimatedPrice() {
        return estimatedPrice;
    }

    public Boolean getPurchased() {
        return purchased;
    }

    public LocalDateTime getAddedAt() {
        return addedAt;
    }
}

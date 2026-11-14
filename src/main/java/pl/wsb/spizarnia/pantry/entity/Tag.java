package pl.wsb.spizarnia.pantry.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.LocalDate;

/** Etykieta produktu, np. „nabiał” albo „wegetariańskie”. Produkty i etykiety łączy tabela pantry_item_tag. */
@Entity
@Table(name = "tag")
public class Tag {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false, unique = true, length = 40)
    private String name;

    /** Kolor etykiety w aplikacji, zapis szesnastkowy, np. #8bc34a. */
    @Column(name = "color", length = 7)
    private String color;

    @Column(name = "description", length = 120)
    private String description;

    @Column(name = "created_at", nullable = false)
    private LocalDate createdAt;

    protected Tag() {
    }

    public Tag(String name, String color, String description) {
        this.name = name;
        this.color = color;
        this.description = description;
        this.createdAt = LocalDate.now();
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getColor() {
        return color;
    }

    public String getDescription() {
        return description;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }
}

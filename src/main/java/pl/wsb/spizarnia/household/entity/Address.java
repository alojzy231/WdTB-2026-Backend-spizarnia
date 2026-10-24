package pl.wsb.spizarnia.household.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

/** Klasa wbudowana: kolumny adresu w tabeli gospodarstwa domowego (bez własnej tabeli). */
@Embeddable
public class Address {

    @Column(name = "street", length = 80)
    private String street;

    /** Tekst, bo numer budynku może mieć literę, np. 12A. */
    @Column(name = "building_number", length = 10)
    private String buildingNumber;

    /** Numer lokalu: opcjonalny, dom jednorodzinny go nie ma. */
    @Column(name = "apartment_number", length = 10)
    private String apartmentNumber;

    @Column(name = "city", length = 40)
    private String city;

    @Column(name = "postal_code", length = 6)
    private String postalCode;

    protected Address() {
    }

    public Address(String street, String buildingNumber, String apartmentNumber, String city, String postalCode) {
        this.street = street;
        this.buildingNumber = buildingNumber;
        this.apartmentNumber = apartmentNumber;
        this.city = city;
        this.postalCode = postalCode;
    }

    public String getStreet() {
        return street;
    }

    public String getBuildingNumber() {
        return buildingNumber;
    }

    public String getApartmentNumber() {
        return apartmentNumber;
    }

    public String getCity() {
        return city;
    }

    public String getPostalCode() {
        return postalCode;
    }
}

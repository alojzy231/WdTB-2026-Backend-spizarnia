package pl.wsb.spizarnia.pantry.entity;

/** Miejsce przechowywania produktu. W bazie zapisywane jako tekst (@Enumerated(EnumType.STRING)). */
public enum StorageLocation {
    FRIDGE,
    FREEZER,
    CUPBOARD
}

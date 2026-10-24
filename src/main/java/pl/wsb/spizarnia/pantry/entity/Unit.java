package pl.wsb.spizarnia.pantry.entity;

/** Jednostka ilości produktu. W bazie zapisywana jako tekst (@Enumerated(EnumType.STRING)). */
public enum Unit {
    PIECE,
    KG,
    G,
    L,
    ML,
    PACK
}

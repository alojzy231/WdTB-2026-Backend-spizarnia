package pl.wsb.spizarnia.pantry.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.wsb.spizarnia.pantry.entity.PantryItem;

import java.util.List;

/** Dostęp do produktów w spiżarni. Spring Data sam pisze SQL na podstawie nazw metod. */
public interface PantryItemRepository extends JpaRepository<PantryItem, Long> {

    /** Produkty ze spiżarni gospodarstwa o podanej nazwie: zapytanie idzie przez relację household. */
    List<PantryItem> findByHousehold_Name(String name);
}

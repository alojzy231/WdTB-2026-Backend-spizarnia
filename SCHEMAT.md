# Schemat bazy danych

Plik generują reguły projektu (panel Maven → Lifecycle → verify). Nie edytujcie go ręcznie.

Tabele: 7 (w tym tabele łączące @ManyToMany: pantry_item_tag) · kolumny: 43 · relacje: 4 × @ManyToOne, 1 × @OneToMany, 1 × @OneToOne, 1 × @ManyToMany

| Tabela | Encja | Kolumny | Klucze obce |
|---|---|---|---|
| household | Household | 9 | — |
| household_member | HouseholdMember | 6 | household_id, user_account_id |
| pantry_item | PantryItem | 9 | household_id |
| shopping_list_item | ShoppingListItem | 9 | household_id, pantry_item_id |
| tag | Tag | 5 | — |
| user_account | UserAccount | 5 | — |

```mermaid
erDiagram
    household {
        Long id PK
        String apartment_number
        String building_number
        String city
        LocalDate created_at
        Integer members_count
        String name
        String postal_code
        String street
    }
    household_member {
        Long id PK
        Long household_id FK
        Boolean is_owner
        LocalDate joined_at
        String nickname
        Long user_account_id FK
    }
    pantry_item {
        Long id PK
        LocalDate expiry_date
        Long household_id FK
        StorageLocation location
        BigDecimal min_quantity
        String name
        Boolean opened
        BigDecimal quantity
        Unit unit
    }
    shopping_list_item {
        Long id PK
        LocalDateTime added_at
        BigDecimal estimated_price
        Long household_id FK
        Long pantry_item_id FK
        String product_name
        Boolean purchased
        BigDecimal quantity
        Unit unit
    }
    tag {
        Long id PK
        String color
        LocalDate created_at
        String description
        String name
    }
    user_account {
        Long id PK
        LocalDateTime created_at
        String display_name
        String email
        AccountRole role
    }
    household ||--o{ household_member : "household_id"
    household ||--o{ pantry_item : "household_id"
    household ||--o{ shopping_list_item : "household_id"
    pantry_item |o--o{ shopping_list_item : "pantry_item_id"
    pantry_item }o--o{ tag : "pantry_item_tag"
    user_account ||--o| household_member : "user_account_id"
```

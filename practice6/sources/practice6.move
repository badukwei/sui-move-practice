module practice6::table {
    use sui::table::{Self, Table};

    public struct IntTable {
        table: Table<u64, u64>
    }

    public struct GenericTable<phantom K: copy + drop + store, phantom V: store> {
        table: Table<K, V>
    }

    // Create a new, empty GenericTable with key type K, and value type V
    public fun create<K: copy + drop + store, V: store>(ctx: &mut TxContext): GenericTable<K, V> {
        GenericTable<K, V> {
            table: table::new<K, V>(ctx)
        }
    }

    // Adds a key-value pair to GenericTable
    public fun add<K: copy + drop + store, V: store>(table: &mut GenericTable<K, V>, k: K, v: V) {
        table::add(&mut table.table, k, v);
    }

    /// Removes the key-value pair in the GenericTable `table: &mut Table<K, V>` and returns the value.   
    public fun remove<K: copy + drop + store, V: store>(table: &mut GenericTable<K, V>, k: K): V {
        table::remove(&mut table.table, k)
    }

    // Borrows an immutable reference to the value associated with the key in GenericTable
    public fun borrow<K: copy + drop + store, V: store>(table: &GenericTable<K, V>, k: K): &V {
        table::borrow(&table.table, k)
    }

    /// Borrows a mutable reference to the value associated with the key in GenericTable
    public fun borrow_mut<K: copy + drop + store, V: store>(table: &mut GenericTable<K, V>, k: K): &mut V {
        table::borrow_mut(&mut table.table, k)
    }

    /// Check if a value associated with the key exists in the GenericTable
    public fun contains<K: copy + drop + store, V: store>(table: &GenericTable<K, V>, k: K): bool {
        table::contains<K, V>(&table.table, k)
    }

    /// Returns the size of the GenericTable, the number of key-value pairs
    public fun length<K: copy + drop + store, V: store>(table: &GenericTable<K, V>): u64 {
        table::length(&table.table)
    }
}
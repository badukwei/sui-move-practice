module practice5::vector {
    use std::vector::{Self};

    public struct Widget {}

    public struct WidgetVector {
        widgets: vector<Widget>
    }

    public struct GenericVector<T> {
        values: vector<T>
    }

     // Creates a GenericVector that holds a generic type T
    public fun create<T>(): GenericVector<T> {
        GenericVector<T> {
            values: vector::empty<T>()
        }
    }

    public fun put<T>(vec: &mut GenericVector<T>, value: T) {
        vector::push_back<T>(&mut vec.values, value);
    }
}


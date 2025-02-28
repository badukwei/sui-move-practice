module practice2::storage {
    use std::string::String;

    public struct Box {
        value: u64
    }

    public struct Box2<T> {
        value: T
    }

    public struct Box3<T: store + drop> has key, store {
        id: UID,
        value: T
    }

    public fun create_box2<T>(value: T): Box2<T> {
        Box2<T> { value }
    }

    public fun create_box2_u64(value: u64): Box2<u64> {
        Box2<u64> { value }
    }

    // value will be of type storage::Box<bool>
    // let bool_box = create_box2<bool>(true);
    // value will be of the type storage::Box<u64>
    //let u64_box = create_box2<u64>(1000000);
}


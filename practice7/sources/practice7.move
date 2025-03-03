module practice7::dynamic_field {
    use sui::dynamic_object_field as ofield;
    use sui::dynamic_field as field;

    // Dynamic Field (DF) vs. Dynamic Object Field (DOF)
    //
    // Dynamic Field (DF):
    // - No `key` ability, data is embedded within parent object, cannot be accessed directly via ID.
    // - Suitable for storing extension attributes or Key-Value structures (like Table), saves storage cost.
    // - Cannot be transferred or deleted independently, must be accessed and managed through parent object.
    //
    // Dynamic Object Field (DOF):
    // - Has `key` ability, each value is an independent Sui object that can be accessed via ID.
    // - Suitable for independently existing objects like NFTs, game items, DeFi positions etc.
    // - Can be transferred or deleted independently, suitable for data that needs cross-contract access.

    public struct Parent has key {
        id: UID,
    }

    public struct DFChild has store {
        count: u64
    }

    public struct DOFChild has key, store {
        id: UID,
        count: u64,
    }
    
    public fun add_dfchild(parent: &mut Parent, child: DFChild, name: vector<u8>) {
        field::add(&mut parent.id, name, child);
    }

    public fun add_dofchild(parent: &mut Parent, child: DOFChild, name: vector<u8>) {
        ofield::add(&mut parent.id, name, child);
    }

    // Mutate a DOFChild directly
    public fun mutate_dofchild(child: &mut DOFChild) {
        child.count = child.count + 1;
    }

    // Mutate a DFChild directly
    public fun mutate_dfchild(child: &mut DFChild) {
        child.count = child.count + 1;
    }

    // Mutate a DFChild's counter via its parent object
    public fun mutate_dfchild_via_parent(parent: &mut Parent, child_name: vector<u8>) {
        let child = field::borrow_mut<vector<u8>, DFChild>(&mut parent.id, child_name);
        child.count = child.count + 1;
    }

    // Mutate a DOFChild's counter via its parent object
    public fun mutate_dofchild_via_parent(parent: &mut Parent, child_name: vector<u8>) {
        mutate_dofchild(ofield::borrow_mut<vector<u8>, DOFChild>(
            &mut parent.id,
            child_name,
        ));
    }

    // Removes a DFChild given its name and parent object's mutable reference, and returns it by value
    public fun remove_dfchild(parent: &mut Parent, child_name: vector<u8>): DFChild {
        field::remove<vector<u8>, DFChild>(&mut parent.id, child_name)
    }

    // Deletes a DOFChild given its name and parent object's mutable reference
    public fun delete_dofchild(parent: &mut Parent, child_name: vector<u8>) {
        let DOFChild { id, count: _ } = ofield::remove<vector<u8>, DOFChild>(
            &mut parent.id,
            child_name,
        );
        object::delete(id);
    }

    // Removes a DOFChild from the parent object and transfers it to the caller
    public fun reclaim_dofchild(parent: &mut Parent, child_name: vector<u8>, ctx: &mut TxContext) {
        let child = ofield::remove<vector<u8>, DOFChild>(
            &mut parent.id,
            child_name,
        );
        transfer::transfer(child, tx_context::sender(ctx));
    }
}



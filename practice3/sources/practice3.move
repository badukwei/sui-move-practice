module practice3::witness {

    public struct Guardian<phantom T: drop> has key, store {
        id: UID
    }
    
    public struct WITNESS has drop {}

    public fun create_guardian<T: drop>(_witness: T, ctx: &mut TxContext): Guardian<T> {
        Guardian {
            id: object::new(ctx)
        }
    }
    
    fun init(witness: WITNESS, ctx: &mut TxContext) {
        transfer::transfer(
            create_guardian(witness, ctx),
            tx_context::sender(ctx)
        )
    }

    /*
    Functions of the Witness Pattern
	1.	Restricting the number of instances of a type
	•	Ensures that a type (e.g., Guardian<T>) can only be created through a specific function (create_guardian) and only once.
	2.	Ensuring resource uniqueness
	•	A witness resource (e.g., WITNESS) is passed as an argument and immediately dropped after use, preventing it from being reused to create multiple instances.
	3.	Preventing resource misuse
	•	Since the witness resource (WITNESS) has only the drop ability, it cannot be stored or transferred. Instead, it is immediately discarded inside create_guardian, ensuring it is used only once.
	4.	Enforcing singleton guarantees with One Time Witness (OTW)
	•	The init function ensures that the witness resource (such as WITNESS) is created only once at module initialization.
	•	This guarantees that Guardian<T> has only one instance.
    */

}


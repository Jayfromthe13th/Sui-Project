module examples::car_rental_with_events {
    use sui::transfer;
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::object::{Self, ID, UID};
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};
    use sui::event;

    const ENotEnough: u64 = 0;

    /// Capability for the rental service owner.
    struct RentalServiceOwnerCap has key { id: UID }

    /// Represents a car available for rent.
    struct Car has key {
        id: UID,
        model: String,
        daily_rate: u64
    }

    /// Represents the car rental service.
    struct CarRentalService has key {
        id: UID,
        balance: Balance<SUI>
    }

    // ====== Events ======

    /// Event emitted when a car is rented.
    struct CarRented has copy, drop {
        car_id: UID,
        renter: address,
        days_rented: u64
    }

    /// Event emitted when a car is returned.
    struct CarReturned has copy, drop {
        car_id: UID,
        renter: address
    }

    // ====== Functions ======

    /// Initialize the car rental service.
    fun init(ctx: &mut TxContext) {
        transfer::transfer(RentalServiceOwnerCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx));

        transfer::share_object(CarRentalService {
            id: object::new(ctx),
            balance: balance::zero()
        })
    }

    /// Rent a car from the service.
    public fun rent_car(
        service: &mut CarRentalService, car: &mut Car, 
        rental_period: u64, payment: &mut Coin<SUI>, ctx: &mut TxContext
    ) {
        assert!(coin::value(payment) >= car.daily_rate * rental_period, ENotEnough);
        
        let coin_balance = coin::balance_mut(payment);
        let paid = balance::split(coin_balance, car.daily_rate * rental_period);
        balance::join(&mut service.balance, paid);

        event::emit(CarRented { 
            car_id: car.id, 
            renter: tx_context::sender(ctx),
            days_rented: rental_period
        });
    }

    /// Return a rented car to the service.
    public fun return_car(
        car: &mut Car, renter: address, ctx: &mut TxContext
    ) {
        // Assume logic to verify renter and car status
        event::emit(CarReturned { 
            car_id: car.id, 
            renter 
        });
    }
}

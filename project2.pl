% Project 2 CPSC312 Haskell
% Poke Simulator  
% TaeGyun(William) Lim - 25983157
% Do Hoon Lee - 26404153
% Hyehwa (Jennifer) Lee - 88516265


% WELCOME TO POKE SIMULATOR

% 1. turn one of the players to computer:
% - randomly picks a pokemon and attacks

% 2. attack is different depending on types (all the possible types):
% - type_attack function

% 3. depending on the pokemon stats, its attack value will be different 
% dohoon you are going to do this 

% 4. test the cases of when you pick an option that is not listed 

% 5. Finalize and test for any bugs
% - different number is in, then it repeats

% DONE:
% If wrong number is entered, then it asks again until the right number is entered
% Option of Play with Computer and Play between users is implemented


:- use_module(library(random)).



play :-
	write("Welcome to our Pokemon Simulator"), nl,
    choose_option(Option),
    (Option = 1 -> play_computer()
    ;Option = 2 -> between_users()
    ;play()).

choose_option(Option) :-
    write("Please choose the battle mode"), nl,
    write("1: Play with computer, 2: Play between two users"), nl,
    read(ChosenOption),
    (ChosenOption = 1 -> Option is 1
    ;ChosenOption = 2 -> Option is 2
    ;write("You have chosen a wrong option. Please retry."), nl, choose_option(Option)).


play_computer() :-
    write("Pick one of the four options"), nl,
    player(Pokemon1),
    random_computer_pick(Pokemon2),
    pokemon(Pokemon2, PokemonName2),
    write("The Computer has choosen a random Pokemon, "), write(PokemonName2), write("."), nl,
	battle_start(Pokemon1, Pokemon2, computer).


between_users() :-
	write("First player: pick one of the four options"), nl,
	player(Pokemon1),
	write("Second player: pick one of the four options"), nl,
	player(Pokemon2),
	battle_start(Pokemon1, Pokemon2, users).



player(ThePokemon) :-
	write("1: Pikachu, 2: Charmander, 3: Bulbasaur, 4: Squirtle"), nl,
	read(Pokemon),
	(Pokemon = 1 -> ThePokemon is 25, write("You have chosen Pikachu."), nl
	;Pokemon = 2 -> ThePokemon is 4, write("You have chosen Charmander."), nl
	;Pokemon = 3 -> ThePokemon is 1, write("You have chosen Bulbasaur."), nl
	;Pokemon = 4 -> ThePokemon is 7, write("You have chosen Squirtle."), nl
	;write("You have chosen the number that is not in the list. Please try again."), nl, player(ThePokemon)).


battle_start(Pokemon1, Pokemon2, Option) :-
	pokemon_speed(Pokemon1, Speed1),
	pokemon_speed(Pokemon2, Speed2),
	pokemon_hp(Pokemon1, HP1),
	pokemon_hp(Pokemon2, HP2),
	pokemon(Pokemon1, PokemonName1),
	pokemon(Pokemon2, PokemonName2),
    (Option = users ->
	(Speed2 =< Speed1
	-> write("Player 1's "),write(PokemonName1), write(" is faster. Therefore, it attacks first."), nl, battle1(Pokemon1, HP1, Pokemon2, HP2)
	; write("Player 2's "),write(PokemonName2), write(" is faster. Therefore, it attacks first."), nl, battle2(Pokemon1, HP1, Pokemon2, HP2))
    ;Option = computer ->
    (Speed2 =< Speed1
	-> write("Player's "), write(PokemonName1), write(" is faster. Therefore, it attacks first."), nl, battle_computer1(Pokemon1, HP1, Pokemon2, HP2)
	;write("Computer's "), write(PokemonName2), write(" is faster. Therefore, it attacks first."), nl, battle_computer2(Pokemon1, HP1, Pokemon2, HP2))
    ;write("")).


battle1(Pokemon1, HP1, Pokemon2, HP2) :-
    write("Player 1's Pokemon has "), write(HP1), write(" HP. Player 2's Pokemon has "), write(HP2), write(" HP."), nl,
    pokemon_skills(Pokemon1, "Player 1"),
    pokemon_type(Pokemon1, PType1),
    pokemon_type(Pokemon2, PType2),
    read(Skill1), nl,
    skill_has(Skill1, Damage1, Pokemon1, SType1, Category1),
    (PType1 = SType1 -> STAB1 is 1.5
    ; STAB1 is 1),
    pokemon_astat(Pokemon1, Astat1),
    pokemon_cstat(Pokemon1, Cstat1),
    pokemon_bstat(Pokemon2, Bstat2),
    pokemon_dstat(Pokemon2, Dstat2),
    type_attack(SType1, PType2, Times1),
    effectiveness(Times1), nl,
    (Category1 = "physical" -> damage_calculator(Damage1, Astat1, STAB1, Times1, Final1), defense_calculator(HP2, Bstat2, Final2)
    ; Category1 = "special" -> damage_calculator(Damage1, Cstat1, STAB1, Times1, Final1), defense_calculator(HP2, Dstat2, Final2)),
    hp_calculator(Final1, Final2, HP2, HP2_after, "Player 2"),
    write("Player 2 has "), write(HP2_after), write(" HP left."), nl,

    pokemon_skills(Pokemon2, "Player 2"),
    read(Skill2), nl,
    skill_has(Skill2, Damage2, Pokemon2, SType2, Category2),
    (PType2 = SType2 -> STAB2 is 1.5
    ; STAB2 is 1),
    pokemon_astat(Pokemon2, Astat2),
    pokemon_cstat(Pokemon2, Cstat2),
    pokemon_bstat(Pokemon1, Bstat1),
    pokemon_dstat(Pokemon1, Dstat1),
    type_attack(SType2, PType1, Times2),
    effectiveness(Times2), nl,
    (Category2 = "physical" -> damage_calculator(Damage2, Astat2, STAB2, Times2, Final4), defense_calculator(HP1, Bstat1, Final3)
    ; Category2 = "special" -> damage_calculator(Damage2, Cstat2, STAB2, Times2, Final4), defense_calculator(HP1, Dstat1, Final3)),
    hp_calculator(Final4, Final3, HP1, HP1_after, "Player 1"),
    write("Player 1 has "), write(HP1_after), write(" HP left."), nl,

    battle1(Pokemon1, HP1_after, Pokemon2, HP2_after), nl.


battle2(Pokemon1, HP1, Pokemon2, HP2) :-
    write("Player 1's Pokemon has "), write(HP1), write(" HP. Player 2's Pokemon has "), write(HP2), write(" HP."), nl,
    pokemon_skills(Pokemon2, "Player 2"),
    pokemon_type(Pokemon2, PType2),
    pokemon_type(Pokemon1, PType1),
    read(Skill2), nl,
    skill_has(Skill2, Damage2, Pokemon2, SType2, Category2),
    (PType2 = SType2 -> STAB2 is 1.5
    ; STAB2 is 1),
    pokemon_astat(Pokemon2, Astat2),
    pokemon_cstat(Pokemon2, Cstat2),
    pokemon_bstat(Pokemon1, Bstat1),
    pokemon_dstat(Pokemon1, Dstat1),
    type_attack(SType2, PType1, Times2),
    effectiveness(Times2), nl,
    (Category2 = "physical" -> damage_calculator(Damage2, Astat2, STAB2, Times2, Final4), defense_calculator(HP1, Bstat1, Final3)
    ; Category2 = "special" -> damage_calculator(Damage2, Cstat2, STAB2, Times2, Final4), defense_calculator(HP1, Dstat1, Final3)),
    hp_calculator(Final4, Final3, HP1, HP1_after, "Player 1"),

    write("Player 1 has "), write(HP1_after), write(" HP left."), nl,

    pokemon_skills(Pokemon1, "Player 1"),
    read(Skill1), nl,
    skill_has(Skill1, Damage1, Pokemon1, SType1, Category1),
    (PType1 = SType1 -> STAB1 is 1.5
    ; STAB1 is 1),
    pokemon_astat(Pokemon1, Astat1),
    pokemon_cstat(Pokemon1, Cstat1),
    pokemon_bstat(Pokemon2, Bstat2),
    pokemon_dstat(Pokemon2, Dstat2),
    type_attack(SType1, PType2, Times1),
    effectiveness(Times1), nl,
    (Category1 = "physical" -> damage_calculator(Damage1, Astat1, STAB1, Times1, Final1), defense_calculator(HP2, Bstat2, Final2)
    ; Category1 = "special" -> damage_calculator(Damage1, Cstat1, STAB1, Times1, Final1), defense_calculator(HP2, Dstat2, Final2)),
    hp_calculator(Final1, Final2, HP2, HP2_after, "Player 2"),
    write("Player 2 has "), write(HP2_after), write(" HP left."), nl,

    battle2(Pokemon1, HP1_after, Pokemon2, HP2_after), nl.




battle_computer1(Pokemon1, HP1, Pokemon2, HP2) :-
    write("Player's Pokemon has "), write(HP1), write(" HP. Computer's Pokemon has "), write(HP2), write(" HP."), nl,
	pokemon_skills(Pokemon1, "Player"),
    pokemon_type(Pokemon1, PType1),
    pokemon_type(Pokemon2, PType2),
    read(Skill1), nl,
    skill_has(Skill1, Damage1, Pokemon1, SType1, Category1),
    (PType1 = SType1 -> STAB1 is 1.5
    ; STAB1 is 1),
    pokemon_astat(Pokemon1, Astat1),
    pokemon_cstat(Pokemon1, Cstat1),
    pokemon_bstat(Pokemon2, Bstat2),
    pokemon_dstat(Pokemon2, Dstat2),
    type_attack(SType1, PType2, Times1),
    effectiveness(Times1), nl,
    (Category1 = "physical" -> damage_calculator(Damage1, Astat1, STAB1, Times1, Final1), defense_calculator(HP2, Bstat2, Final2)
    ; Category1 = "special" -> damage_calculator(Damage1, Cstat1, STAB1, Times1, Final1), defense_calculator(HP2, Dstat2, Final2)),
    hp_calculator(Final1, Final2, HP2, HP2_after, "Computer"),
    write("Computer has "), write(HP2_after), write(" HP left."), nl,

    write("Now it is the computer's turn to attack."), nl,
    write("GENERATING ATTACK"), nl,
    random_move(Pokemon2, Skill2),
    pokemon(Pokemon2, PokemonName2),
    write(PokemonName2), write(" has used "), write(Skill2), write("."), nl,

    skill_has(Skill2, Damage2, Pokemon2, SType2, Category2),
    (PType2 = SType2 -> STAB2 is 1.5
    ; STAB2 is 1),
    pokemon_astat(Pokemon2, Astat2),
    pokemon_cstat(Pokemon2, Cstat2),
    pokemon_bstat(Pokemon1, Bstat1),
    pokemon_dstat(Pokemon1, Dstat1),
    type_attack(SType2, PType1, Times2),
    effectiveness(Times2), nl,
    (Category2 = "physical" -> damage_calculator(Damage2, Astat2, STAB2, Times2, Final4), defense_calculator(HP1, Bstat1, Final3)
    ; Category2 = "special" -> damage_calculator(Damage2, Cstat2, STAB2, Times2, Final4), defense_calculator(HP1, Dstat1, Final3)),
    hp_calculator(Final4, Final3, HP1, HP1_after, "Player"),

    write("Player has "), write(HP1_after), write(" HP left."), nl,

    battle_computer1(Pokemon1, HP1_after, Pokemon2, HP2_after), nl.


battle_computer2(Pokemon1, HP1, Pokemon2, HP2) :-
    write("Player's Pokemon has "), write(HP1), write(" HP. Computer's Pokemon has "), write(HP2), write(" HP."), nl,
    write("Computer attacks."), nl,
    write("GENERATING ATTACK"), nl,
    random_move(Pokemon2, Skill2),
    pokemon(Pokemon2, PokemonName2),
    write(PokemonName2), write(" has used "), write(Skill2), write("."), nl,
    pokemon_type(Pokemon2, PType2),
    pokemon_type(Pokemon1, PType1),
    skill_has(Skill2, Damage2, Pokemon2, SType2, Category2),
    (PType2 = SType2 -> STAB2 is 1.5
    ; STAB2 is 1),
    pokemon_astat(Pokemon2, Astat2),
    pokemon_cstat(Pokemon2, Cstat2),
    pokemon_bstat(Pokemon1, Bstat1),
    pokemon_dstat(Pokemon1, Dstat1),
    type_attack(SType2, PType1, Times2),
    effectiveness(Times2), nl,
    (Category2 = "physical" -> damage_calculator(Damage2, Astat2, STAB2, Times2, Final4), defense_calculator(HP1, Bstat1, Final3)
    ; Category2 = "special" -> damage_calculator(Damage2, Cstat2, STAB2, Times2, Final4), defense_calculator(HP1, Dstat1, Final3)),
    hp_calculator(Final4, Final3, HP1, HP1_after, "Player"),
    write("Player has "), write(HP1_after), write(" HP left."), nl,

	pokemon_skills(Pokemon1, "Player"),
    read(Skill1), nl,
    skill_has(Skill1, Damage1, Pokemon1, SType1, Category1),
    (PType1 = SType1 -> STAB1 is 1.5
    ; STAB1 is 1),
    pokemon_astat(Pokemon1, Astat1),
    pokemon_cstat(Pokemon1, Cstat1),
    pokemon_bstat(Pokemon2, Bstat2),
    pokemon_dstat(Pokemon2, Dstat2),
    type_attack(SType1, PType2, Times1),
    effectiveness(Times1), nl,
    (Category1 = "physical" -> damage_calculator(Damage1, Astat1, STAB1, Times1, Final1), defense_calculator(HP2, Bstat2, Final2)
    ; Category1 = "special" -> damage_calculator(Damage1, Cstat1, STAB1, Times1, Final1), defense_calculator(HP2, Dstat2, Final2)),
    hp_calculator(Final1, Final2, HP2, HP2_after, "Computer"),
    write("Computer has "), write(HP2_after), write(" HP left."), nl,
    
    battle_computer2(Pokemon1, HP1_after, Pokemon2, HP2_after), nl.


damage_calculator(Damage, Stat, STAB, TypeMult, Final) :-
    Result is Damage * Stat * STAB * TypeMult,
    rounddown(Result,Final).

defense_calculator(HP, Stat, Final) :-
    Result is HP * Stat / 0.411,
    rounddown(Result,Final).

hp_calculator(DamageValue, DefensiveValue, HP_before, HP_after, HP_of) :- 
    Result is 100 * DamageValue / DefensiveValue,
    rounddown(Result,Damage),
    HP_after is HP_before - Damage,
	(HP_after =< 0 -> 
    write(HP_of), write("'s"), write(" Pokemon has fainted. The game ended."), fail
	; write("")).


effectiveness(TypeMult) :-
    (TypeMult = 2, write("It's super effective!")
    ; TypeMult = 0.5, write("It's not very effective...")
    ; TypeMult = 1, write("")).

pokemon_skills(Pokemon, User) :- 
    pokemon_has(Pokemon,ListSkills),
    pokemon(Pokemon,PokemonName),
    write("Please pick the skill you want to use."), nl,
    write(User), write("'s "),
	write(PokemonName),
    write(" has skills: "),
    write(ListSkills), nl.


% helper: random_computer_pick(pokemon_list)
random_computer_pick(X) :- 
	random_member(X,[25,4,1,7]).


% helper: random_move(pokemon,pokemon_move)
random_move(X,Y) :-
	(X = 25 -> random_member(Y,[thunderbolt,tackle])
	; X = 4 -> random_member(Y,[flamethrower,tackle])
	; X = 1 -> random_member(Y,[razorleaf,tackle])
	; X = 7 -> random_member(Y,[surf,tackle])
	; write("")). 


% DATA ----------


pokemon(25,'Pikachu').
pokemon(4,'Charmander').
pokemon(1,'Bulbasaur').
pokemon(7,'Squirtle').



% helper: pokemon_has(Pokemon_number, List_of_skills)
pokemon_has(25, [thunderbolt,tackle]).
pokemon_has(4, [flamethrower,tackle]).
pokemon_has(1,[razorleaf,tackle]).
pokemon_has(7,[surf,tackle]).


% helper: pokemon_hp(Pokemon_number, HP)
pokemon_hp(25,35).
pokemon_hp(4,45).
pokemon_hp(1,39).
pokemon_hp(7,44).



list_of_skills([thunderbolt, razorleaf, surf, flamethrower, tackle]).


skill_has(TakenName, Damage, Pokemon, Type, Category) :- 
    list_of_skills(ListOfSkills),
    (member(TakenName,ListOfSkills) ->
        pokemon_has(Pokemon, ListOfPokemonSkills),
        (member(TakenName,ListOfPokemonSkills) ->
            % Case 1: TakenName is a valid skill, the pokemon has the skill
            skills(TakenName,Damage), skill_type(TakenName,Type), skill_category(TakenName,Category)
            ;% Case 2: TakenName is a valid skill, the pokemon does not have the skill
            write("Your Pokemon does not have the skill. Please try again"), nl,
            read(NewTakenName),
            skill_has(NewTakenName, Damage, Pokemon, Type, Category)
        )
        % Case 3: TakenName is not a valid skill
        ;write("The following skill does not exist. Please try again."),nl,
        read(NewTakenName),
        skill_has(NewTakenName, Damage, Pokemon, Type, Category)
    ).
    


% helper: skills(Skill, Damage)
skills(thunderbolt, 10).
skills(razorleaf, 10).
skills(surf, 10).
skills(flamethrower, 10).
skills(tackle, 5).


% helper: skill_category(Skill, Category)
skill_category(thunderbolt, "special").
skill_category(razorleaf, "physical").
skill_category(surf, "special").
skill_category(flamethrower, "special").
skill_category(tackle, "physical").

% helper: skill_type(Skill, Type)
skill_type(thunderbolt,electric).
skill_type(razorleaf,grass).
skill_type(surf,water).
skill_type(flamethrower,fire).
skill_type(tackle,normal).


% helper: pokemon_speed(Pokemon, Speed)
pokemon_speed(25, X) :-
	random_between(85,95,X).
pokemon_speed(4, X) :-
	random_between(80,90,X).
pokemon_speed(1, X) :-
	random_between(75,85,X).
pokemon_speed(7, X) :-
	random_between(78,88,X).	


% helper: pokemon_type(Pokemon, Type)
pokemon_type(25, electric).
pokemon_type(4, fire).
pokemon_type(1, grass).
pokemon_type(7, water).


% helper: type_attack(Type1, Type2, Times)
% if Type1 attacks Type2, then by how many Times does the attack increase by
type_attack(water, grass, 0.5).
type_attack(water, water, 0.5).
type_attack(water, fire, 2).
type_attack(water, electric, 1).

type_attack(electric, electric, 0.5).
type_attack(electric, fire, 1).
type_attack(electric, grass, 0.5).
type_attack(electric, water, 2).

type_attack(fire, grass, 2).
type_attack(fire, water, 0.5).
type_attack(fire, fire, 0.5).
type_attack(fire, electric, 1).

type_attack(grass, water, 2).
type_attack(grass, fire, 0.5).
type_attack(grass, electric, 1).
type_attack(grass, grass, 0.5).

type_attack(normal, electric, 1).
type_attack(normal, fire, 1).
type_attack(normal, grass, 1).
type_attack(normal, water, 1).

% helper: all calculation results are rounded down in Pokemon game
rounddown(Number,Result) :-
    New is Number-0.5,
    round(New,Result).

% helper: pokemon_stat(Pokemon, Stat)
pokemon_astat(25,55).
pokemon_astat(1,49).
pokemon_astat(4,52).
pokemon_astat(7,48).

pokemon_bstat(25,40).
pokemon_bstat(1,49).
pokemon_bstat(4,43).
pokemon_bstat(7,65).

pokemon_cstat(25,50).
pokemon_cstat(1,65).
pokemon_cstat(4,60).
pokemon_cstat(7,50).

pokemon_dstat(25,50).
pokemon_dstat(1,65).
pokemon_dstat(4,50).
pokemon_dstat(7,64).

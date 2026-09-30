cmake_minimum_required(VERSION 3.23)


# TODO1: Implement MacroAppend

# La macro MacroAppend prend en argument la liste original_list et un argument à ajouter à la list
# Dévelloper la variable ${original_list} donne le nom de la list
# Dévelloper la variable ${${original_list}} donne le contenu de la list
# la fonction set() prend en premier argument le nom de la variable à definir (ici la liste)
# et en second argument la variable attibuer a la liste (ici la liste original ${{original_list}} et le nouvelle ajout ${argument})


macro(MacroAppend original_list argument)
  set(${original_list} ${${original_list}};${argument})
endmacro()

# TODO2: Call MacroAppend, then return the value from FuncAppend
function(FuncAppend ListVar Value)

endfunction()



# Testing for the above, final expected value is "Alpha;Beta;Gamma;Delta"
if(SKIP_TESTS)
  return()
endif()

set(Original "Beta;Gamma")
set(Expected "Alpha;Beta;Gamma;Delta")

set(BeginList ${Original})
set(EndList "Alpha")

MacroAppend(BeginList "Delta")
foreach(value IN LISTS BeginList)
  MacroAppend(EndList ${value})
endforeach()

if(BeginList STREQUAL Original)
  message("MacroAppend unimplemented or did nothing")
elseif(NOT EndList STREQUAL Expected)
  message(WARNING "MacroAppend error, final value: ${EndList}")
else()
  message("MacroAppend correct")
endif()

set(BeginList ${Original})
set(EndList "Alpha")

FuncAppend(BeginList "Delta")
foreach(value IN LISTS BeginList)
  FuncAppend(EndList ${value})
endforeach()

if(BeginList STREQUAL Original)
  message("FuncAppend unimplemented or did nothing")
elseif(NOT EndList STREQUAL Expected)
  message(WARNING "FuncAppend error, final value: ${EndList}")
else()
  message("FuncAppend correct")
endif()

# Bonus Tests

FuncAppend(UndefinedList "Test")

set(EmptyList "")
FuncAppend(EmptyList "Test")

set(FalseList "False")
FuncAppend(FalseList "Test")

if(
  (UndefinedList STREQUAL "Test") AND
  (EmptyList STREQUAL "Test") AND
  (FalseList STREQUAL "False;Test")
)
  message("You implemented the empty list case, well done!")
endif()

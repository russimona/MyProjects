; RUS SIMONA CATALINA
; GRUPA 30219 


; SNAKE - sarpele se misca prin labirint 
;		- sarpele creste cand mananca un mar bun, insa scade cand mananca un mar cu vierme 
;		- merele se genereaza aleator, iar cele cu vierme dispar la fiecare 15 secunde si reapar ulterior 
;		- sarpele moare daca se bate de zid sau daca se musca de coada si jocul reincepe de la 0
;		- ca si scor, pentru fiecare mar bun mancat creste cu 20, iar pentru fiecare mar cu vierme mancat scade cu 10
;		- controlul sarpelui se realizeaza cu ajutorul sagetilor desenate in partea dreapta a ferestrei 

.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf: proc 
extern calloc: proc 
extern free: proc 
includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data;aici declaram date

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; liste snake ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
node struct 
	next dd 0
	prev dd 0
	i dd 0
	j dd 0
node ends 

head DD 0
elem_curent DD 0
ant_elem_curent DD 0
newnode DD 0 

next EQU 0
prev EQU 4
i_list EQU 8
j_list EQU 12

i0 dd 0 
i1 dd 0

j0 dd 0
j1 dd 0 

index_snake_bite dd 0

move dd 0

arg1 EQU 8
arg2 EQU 12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fail_game dd 0 

window_title DB "Snake",0
area_width EQU 602
area_height EQU 400 ; de la 0 la 399 -> 400 

labirint_size EQU 400
area DD 0

game_x DD 0
game_y DD 0 

snake_x DD 0
snake_y DD 0

food_x DD 0
food_y DD 0

worm_x DD 0
worm_y DD 0

index_worm DD 0
index_food DD 0

index_snake DD 0 
index_food_up DD 0 

symbol_size EQU 20

format_intreg DB "%d", 0


counter DD 0 ; numara evenimentele de tip timer
counter_ok dd 0  ; dupa ac timp dispare textul ok 

; butoanele de control 
controls_size EQU 40
format_natural dd "%d ", 0
new_line dd 10, 13 
i dd 0
j dd 0

x dd 0
y dd 0

x0 dd 0
y0 dd 0 

index dd 0 

up_x EQU 480
up_y EQU 300 
 
down_x EQU 480
down_y EQU 340

left_x EQU 440
left_y EQU 340

right_x EQU 520
right_y EQU 340 

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

scor_joc DD 0
scor_food DD 0
scor_worm DD 0

matrice_joc DD 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 ,9 ,9 ,9 ,9 ,9 ,9 ,9 ,9 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,9
			DD 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 ,9 ,9 ,9 ,9 ,9 ,9 ,9 ,9 ,9

symbol_width EQU 10
symbol_height EQU 20
symbol_game_width EQU 20
symbol_game_height EQU 20
include digits.inc
include letters.inc
include symbol.inc 


.code

 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; macro create_node ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

create_snake_head_macro macro i_list, j_list
	push j_list
	push i_list 
	call create_node
	mov head, eax 
endm 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; macro adauga_node ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

adauga_snake_elem_macro macro i_list, j_list
	push j_list
	push i_list 
	call adauga_node
	mov head, eax 
endm 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;; macro sterg_ node ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sterge_snake_elem_macro macro 
	call sterge_node
endm 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; macro move snake ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_snake_macro macro
	call move_snake
endm 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; creeaza primul nod al listei ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 
; functia create_node creeaza un nod ( ii aloca spatiu de memorie )
; atribuie lui head o adresa 
; atribuie lui i, j, move valori 

create_node proc ; create_node ( i, j, move)
	push ebp
	mov ebp, esp

	; se aloca memorie pentru un nod
	push node 
	push 1
	call calloc 
	add esp, 8
	
	mov dword ptr [eax+next], eax ; in node->next = node 
	mov dword ptr [eax+prev], eax ; in node->prev = node 
	
	mov ebx, [ebp+arg1]
	mov dword ptr [eax+i_list], ebx 
	
	mov ebx, [ebp+arg2]
	mov dword ptr [eax+j_list], ebx
	
	
	mov esp, ebp
	pop ebp
	ret 8
create_node endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; adauga nod la lista ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;functia adauga_node aloca memorie pentru un nod nou
;asociaza valori lui i, j si move pentru nodul alocat
;leaga noul nod la finalul listei
;returneaza adresa primului element din lista 

adauga_node proc ; adauga_nod ( i, j, move )
	push ebp
	mov ebp, esp
	
	push node 
	push 1
	call calloc 
	add esp, 8		; aloca memorie pentru un nod 
		
	mov newnode, eax 
	
	mov ebx, [ebp+arg1]						 
	mov dword ptr [eax+i_list], ebx				; newnode->i = i
	
	mov ebx, [ebp+arg2]
	mov dword ptr [eax+j_list], ebx 				; newnode->j = j 
	
	
	mov eax, newnode
	mov ebx, head 
	
	mov ecx, dword ptr [ebx+prev]			; ecx = ultimul element 
	mov edx, newnode
	mov dword ptr [ecx+next], edx 			; ultimul element -> next = new node 
	
	mov dword ptr [edx+prev], ecx			; new node -> prev - ultimul elem 
	
	mov eax, newnode
	mov ebx, head
	mov dword ptr [eax+next], ebx 			; newnode->next = head 
	
	mov ecx, head
	mov dword ptr [ecx+prev], eax			; head->prev = newnode
	
	
	mov eax, head 						; functia returneaza adresa elementului head 
	mov esp, ebp
	pop ebp 
	ret 8
adauga_node endp 




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; sterge nod din lista ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; functia leaga peuntimul nod de primul
; dezaloca ( sterge ) ultimul nod 
sterge_node proc 
	push ebp
	mov ebp, esp
	
	mov ebx, head 							; in ebx se salveaza pointer spre primul elem din lista 
	mov ecx, dword ptr [ebx+prev]			; ecx = ultimul element din lista 
	
	mov eax, dword ptr [ecx+prev] 			; eax = peuntimul element din lista 
	mov dword ptr [eax+next], ebx 			; peuntimul elem -> next = head 
	
	mov dword ptr [ebx+prev], eax			; head -> prev = penultimul element 

	
	push ecx
	call free
	add esp, 4 
	
	
	mov eax, head
	mov esp, ebp
	pop ebp 
	ret 
sterge_node endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MOVE SNAKE DIRECTION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_snake proc  
	push ebp
	mov ebp, esp

	cmp move, 0 
	je move_snake_up
	
	cmp move, 1 
	je move_snake_down 
	
	cmp move, 2
	je move_snake_left 
	
	cmp move, 3 
	je move_snake_right 

move_snake_up :
			; i scade cu 1 
				
				mov eax, head
				mov ebx, dword ptr [eax+i_list]
				mov i0, ebx 
				
				mov ebx, dword ptr [eax+j_list]
				mov j0, ebx 
			
				mov ebx, dword ptr [head+next]
				mov elem_curent, ebx 				;incepem de la al doilea element din lista 
				
			
		    bucla_lista_up :

				mov eax, elem_curent
				mov ebx, dword ptr[eax+i_list]
				mov i1, ebx 
				mov ecx, dword ptr[eax+j_list] 
				mov j1, ecx 						; in i1 si j1 se salveaza i si j elementului curent
				
				mov edx, i0
				mov eax, elem_curent
				mov dword ptr[eax+i_list], edx 
				
				mov edx, j0 
				mov eax, elem_curent
				mov dword ptr[eax+j_list], edx 			; in elementul curent s-au pus i si j ale elem anterior 
				
				mov eax, i1 
				mov i0, eax 
				
				mov eax, j1
				mov j0, eax	
				
				
				mov ebx, elem_curent 				; elem_curent = elem_curent -> next 
				mov ecx, dword ptr[ebx+next] 
				mov elem_curent, ecx 
				
				cmp head, ecx
				je out_move_snake_up
				
				
			jmp bucla_lista_up
				
				 	
	out_move_snake_up :
	
	mov eax, head 
	mov ebx, dword ptr[eax+i_list]
	dec ebx 
	mov dword ptr[eax+i_list], ebx 
	
	jmp out_move_snake
		
				
move_snake_down : 				
				; i creste cu 1 
				
				mov eax, head
				mov ebx, dword ptr [eax+i_list]
				mov i0, ebx 
				
				mov ebx, dword ptr [eax+j_list]
				mov j0, ebx 
			
				mov ebx, dword ptr [head+next]
				mov elem_curent, ebx 				;incepem de la al doilea element din lista 
				
			
		    bucla_lista_down :

				mov eax, elem_curent
				mov ebx, dword ptr[eax+i_list]
				mov i1, ebx 
				mov ecx, dword ptr[eax+j_list] 
				mov j1, ecx 						; in i1 si j1 se salveaza i si j elementului curent
				
				mov edx, i0
				mov eax, elem_curent
				mov dword ptr[eax+i_list], edx 
				
				mov edx, j0 
				mov eax, elem_curent
				mov dword ptr[eax+j_list], edx 			; in elementul curent s-au pus i si j ale elem anterior 
				
				mov eax, i1 
				mov i0, eax 
				
				mov eax, j1
				mov j0, eax	
				
				
				mov ebx, elem_curent 				; elem_curent = elem_curent -> next 
				mov ecx, dword ptr[ebx+next] 
				mov elem_curent, ecx 
				
				cmp head, ecx
				je out_move_snake_down
				
				
			jmp bucla_lista_down
				
				 	
	out_move_snake_down :
	
	mov eax, head 
	mov ebx, dword ptr[eax+i_list]
	inc ebx 
	mov dword ptr[eax+i_list], ebx 
	
	jmp out_move_snake
		

move_snake_left :
			; j scade cu 1 
				
				mov eax, head
				mov ebx, dword ptr [eax+i_list]
				mov i0, ebx 
				
				mov ebx, dword ptr [eax+j_list]
				mov j0, ebx 
			
				mov ebx, dword ptr [head+next]
				mov elem_curent, ebx 				;incepem de la al doilea element din lista 
				
			
		    bucla_lista_left :

				mov eax, elem_curent
				mov ebx, dword ptr[eax+i_list]
				mov i1, ebx 
				mov ecx, dword ptr[eax+j_list] 
				mov j1, ecx 						; in i1 si j1 se salveaza i si j elementului curent
				
				mov edx, i0
				mov eax, elem_curent
				mov dword ptr[eax+i_list], edx 
				
				mov edx, j0 
				mov eax, elem_curent
				mov dword ptr[eax+j_list], edx 			; in elementul curent s-au pus i si j ale elem anterior 
				
				mov eax, i1 
				mov i0, eax 
				
				mov eax, j1
				mov j0, eax	
				
				
				mov ebx, elem_curent 				; elem_curent = elem_curent -> next 
				mov ecx, dword ptr[ebx+next] 
				mov elem_curent, ecx 
				
				cmp head, ecx
				je out_move_snake_left
				
				
			jmp bucla_lista_left
				
				 	
	out_move_snake_left :
	
	mov eax, head 
	mov ebx, dword ptr[eax+j_list]
	dec ebx 
	mov dword ptr[eax+j_list], ebx 
	
	jmp out_move_snake	


move_snake_right :
			; i scade cu 1 
				
				mov eax, head
				mov ebx, dword ptr [eax+i_list]
				mov i0, ebx 
				
				mov ebx, dword ptr [eax+j_list]
				mov j0, ebx 
			
				mov ebx, dword ptr [head+next]
				mov elem_curent, ebx 				;incepem de la al doilea element din lista 
				
			
		    bucla_lista_right :

				mov eax, elem_curent
				mov ebx, dword ptr[eax+i_list]
				mov i1, ebx 
				mov ecx, dword ptr[eax+j_list] 
				mov j1, ecx 						; in i1 si j1 se salveaza i si j elementului curent
				
				mov edx, i0
				mov eax, elem_curent
				mov dword ptr[eax+i_list], edx 
				
				mov edx, j0 
				mov eax, elem_curent
				mov dword ptr[eax+j_list], edx 			; in elementul curent s-au pus i si j ale elem anterior 
				
				mov eax, i1 
				mov i0, eax 
				
				mov eax, j1
				mov j0, eax	
				
				
				mov ebx, elem_curent 				; elem_curent = elem_curent -> next 
				mov ecx, dword ptr[ebx+next] 
				mov elem_curent, ecx 
				
				cmp head, ecx
				je out_move_snake_right
				
				
			jmp bucla_lista_right
				
				 	
	out_move_snake_right :
	
	mov eax, head 
	mov ebx, dword ptr[eax+j_list]
	inc ebx 
	mov dword ptr[eax+j_list], ebx 
	
	jmp out_move_snake
	
out_move_snake:

	mov eax, head
	mov esp, ebp
	pop ebp 
	ret 
move_snake endp
 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GENERATE GOOD FOOD ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GOOD_APPLE_FOOD macro 
	
	mov eax, index_food
	mov matrice_joc[eax], 0

	generate_x_y
	mov food_x, eax 
	
	generate_x_y
	mov food_y, eax 
	
	mov eax, food_y
	mov ebx, symbol_size
	mul ebx 
	add eax, food_x  
	
	
	shl eax, 2 
	mov index_food, eax 
	mov matrice_joc[eax] , 8
	
	
endm 


line_horizontal macro x, y, lenght, color
local  bucla_line

	mov eax, y  
	mov ebx, area_width
	mul ebx 
	add eax, x ; EAX = y*area_width + x 
	shl eax, 2 ; EAX = (y*area_width + x) * 4  
	add eax, area
	
	mov ecx, lenght
bucla_line :

	mov dword ptr[eax], color
	add eax, 4
	loop bucla_line
endm


line_vertical macro x, y, lenght, color
local bucla_line
	
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	
	mov ecx, lenght
bucla_line :
	mov dword ptr[eax], color  ; -4*area_width
	add eax, area_width*4
	loop bucla_line
	
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; generate x & y -> [2,18] ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


generate_x_y macro 
local generate
generate : 
	rdtsc
	mov edx, 0
	mov ecx, 20
	
	div ecx
	cmp edx, 2
	jl generate
	
	cmp edx, 17
	jg generate 
	mov eax, edx 
	
endm  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; draw symblol ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


draw_symbol_game proc

	push ebp
	mov ebp, esp
	pusha
	
	
	mov eax,[ebp+arg1] ; simbolul pe care il desenam
	lea esi, empty

draw_text:
	mov ebx, symbol_game_width
	mul ebx
	mov ebx, symbol_game_height
	mul ebx
	shl eax, 2
	add esi, eax
	mov ecx, symbol_game_height
	
	
simbol_linii_color:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_game_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_game_width
	
	
bucla_simbol_coloane_snake_color:
	cmp dword ptr [esi], 0
	je simbol_pixel_white

	cmp dword ptr [esi], 1
	je simbol_pixel_black
	
	cmp dword ptr [esi], 2
	je simbol_pixel_light_green
	
	cmp dword ptr [esi], 3
	je simbol_pixel_dark_green
	
	cmp dword ptr [esi], 4
	je simbol_pixel_red
	
	cmp dword ptr [esi], 5
	je simbol_pixel_very_dark_green
	
	cmp dword ptr [esi], 6
	je simbol_pixel_light_pink
	
	cmp dword ptr [esi], 8 
	je simbol_pixel_grass
	
	cmp dword ptr [esi], 9
	je simbol_pixel_snake
		
simbol_pixel_white:
	mov dword ptr [edi], 0ffffffh
	jmp simbol_pixel_next_snake
	
simbol_pixel_black:
	mov dword ptr [edi], 0
	jmp simbol_pixel_next_snake
	
simbol_pixel_light_green:
	mov dword ptr [edi], 0003300h
	jmp simbol_pixel_next_snake
	
simbol_pixel_dark_green:
	mov dword ptr [edi], 0006600h
	jmp simbol_pixel_next_snake
	
simbol_pixel_red :
	mov dword ptr [edi], 0ff0000h
	jmp simbol_pixel_next_snake	
	
simbol_pixel_very_dark_green:
	mov dword ptr [edi], 066ff33h
	jmp simbol_pixel_next_snake

simbol_pixel_light_pink:
	mov dword ptr [edi], 0ffcccch 
	jmp simbol_pixel_next_snake
	
simbol_pixel_grass:
	mov dword ptr [edi], 000a600h 
	jmp simbol_pixel_next_snake
	
simbol_pixel_snake:	
	mov dword ptr [edi], 0FF6347h 
	jmp simbol_pixel_next_snake
	
	
simbol_pixel_next_snake:
	add esi, 4
	add edi, 4
	loop bucla_simbol_coloane_snake_color
	pop ecx
	dec ecx 
	cmp ecx, 0
	jne simbol_linii_color
	
	
	popa
	mov esp, ebp
	pop ebp
	ret

draw_symbol_game endp 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; deseneaza text ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y


make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit	
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
	
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0FFFFFFh
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; macro ca sa apelam mai usor desenarea text ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; macro ca sa apelam mai usor desenarea simbol ;;;;;;;;;;;;;;;;;;;;;
draw_symbol_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call draw_symbol_game
	add esp, 16
endm



; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 0
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	
evt_click:
	
	;;;;;;;;;;;;;;;;;;;; arg2 -> x
	;;;;;;;;;;;;;;;;;;;; arg3 -> y 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; verifica daca s-a dat click in interiorul matrice_joc 

verif_matrice_joc :
	mov eax, [ebp+arg2] ; x
	mov ebx, 0 
	cmp eax, ebx 
	jb verif_up 
	 
	mov ebx, 400
	cmp eax, ebx 
	ja verif_up
	
	;;;;;;;;;;;;;;;;;;;  0 <= y <= 400
	mov eax, [ebp+arg3]
	mov ebx, 0
	cmp eax, ebx 
	jb button_controls
	
	mov ebx, 400 
	cmp eax, ebx 
	ja button_controls
	
	jmp button_matrice_joc  
	jmp button_controls
	
button_matrice_joc :
	mov eax, 0
	mov fail_game, eax 
	jmp evt_timer
	
button_controls:	

verif_up : 
	;;;;;;;;;;;;;;;;;;;; 480 <= x <= 520
	mov eax, [ebp+arg2] ; x
	mov ebx, 480 
	cmp eax, ebx 
	jb verif_down 
	 
	mov ebx, 520 
	cmp eax, ebx 
	ja verif_down
	
	;;;;;;;;;;;;;;;;;;;  300 <= y <= 340 
	mov eax, [ebp+arg3]
	mov ebx, 300
	cmp eax, ebx 
	jb verif_down
	
	mov ebx, 340 
	cmp eax, ebx 
	ja verif_down
	
	jmp button_up 
	 
	
	
verif_down :	
	
	;;;;;;;;;;;;;;;;;;;; 480 <= x <= 520
	mov eax, [ebp+arg2] ; x
	mov ebx, 480 
	cmp eax, ebx 
	jb verif_left 
	 
	mov ebx, 520 
	cmp eax, ebx 
	ja verif_left
	
	;;;;;;;;;;;;;;;;;;;  340 <= y <= 380
	mov eax, [ebp+arg3]
	mov ebx, 340
	cmp eax, ebx 
	jb verif_left
	
	mov ebx, 380 
	cmp eax, ebx 
	ja verif_left
	
	jmp button_down 
	

verif_left :
	
		;;;;;;;;;;;;;;;;;;;; 440 <= x <= 480
	mov eax, [ebp+arg2] ; x
	mov ebx, 440 
	cmp eax, ebx 
	jb verif_right 
	 
	mov ebx, 480 
	cmp eax, ebx 
	ja verif_right
	
	;;;;;;;;;;;;;;;;;;;  340 <= y <= 380
	mov eax, [ebp+arg3]
	mov ebx, 340
	cmp eax, ebx 
	jb verif_right
	
	mov ebx, 380 
	cmp eax, ebx 
	ja verif_right
	
	jmp button_left 


verif_right :
	
		;;;;;;;;;;;;;;;;;;;; 520 <= x <= 650
	mov eax, [ebp+arg2] ; x
	mov ebx, 520 
	cmp eax, ebx 
	jb button_controls_fail 
	 
	mov ebx, 560 
	cmp eax, ebx 
	ja button_controls_fail 
	
	;;;;;;;;;;;;;;;;;;;  340 <= y <= 380
	mov eax, [ebp+arg3]
	mov ebx, 340
	cmp eax, ebx 
	jb button_controls_fail 
	
	mov ebx, 380 
	cmp eax, ebx 
	ja button_controls_fail 
	
	jmp button_right  

button_up :
	mov move, 0
	jmp evt_timer
	
button_down:
	mov move, 1
	jmp evt_timer
		
button_left:
	mov move, 2
	jmp evt_timer
		
button_right:
	mov move, 3 
	jmp evt_timer
	
button_controls_fail :
	make_text_macro ' ', area, 495, 260
	jmp evt_timer 
	
evt_timer:
	inc counter
	inc counter_ok
	
afisare_litere:
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	; mov ebx, 10
	; mov eax, counter
	;;cifra unitatilor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 30, 10
	;;cifra zecilor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 20, 10
	;;cifra sutelor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 10, 10
	
	;scriem un mesaj
	

	cmp counter, 0
	je start_joc 
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; afisam valoarea scor_joc curent (sute, zeci si unitati)

     ; mov eax, counter 
	 ; mov ebx, 1
	 ; div ebx 
	 ; cmp edx, 0 
	 ; jb end_start_joc

	mov ebx, 10
	mov eax, scor_joc
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 500, 120
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 490, 120
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 480, 120
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; afisam valoarea scor_food curent (zeci si unitati)
	
	mov ebx, 10
	mov eax, scor_food
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 470, 160
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 460, 160
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; afisam valoarea scor_worm curent (zeci si unitati)
	
	mov ebx, 10
	mov eax, scor_worm
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 470, 200
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 460, 200
	
	make_text_macro 'S', area, 410, 120
	make_text_macro 'C', area, 420, 120
	make_text_macro 'O', area, 430, 120
	make_text_macro 'R', area, 440, 120
	make_text_macro 'E', area, 450, 120
	draw_symbol_macro 7, area, 460, 120
	
	
	draw_symbol_macro 11, area, 410, 160
	draw_symbol_macro 7, area, 440, 160
	
	draw_symbol_macro 12, area, 410, 200	
	draw_symbol_macro  7, area, 440, 200 
	
	draw_symbol_macro 13, area, 420, 50	;S
	draw_symbol_macro 14, area, 450, 50 ;N
	draW_symbol_macro 15, area, 480, 50 ;A
	draW_symbol_macro 16, area, 510, 50 ;K
	draw_symbol_macro 17, area, 540, 50 ;E
	
	; buton pentru up 
	line_horizontal up_x, up_y, controls_size, 066ff33h
	line_vertical up_x, up_y, controls_size, 066ff33h
	line_horizontal up_x, up_y+controls_size, controls_size, 066ff33h
	line_vertical up_x+controls_size, up_y, +controls_size, 066ff33h
	
	draw_symbol_macro 3, area, up_x+10, up_y+10
	
	;buton pentru down 
	line_horizontal down_x, down_y, controls_size, 066ff33h
	line_vertical down_x, down_y, controls_size, 066ff33h
	line_vertical down_x+controls_size, down_y, controls_size, 066ff33h
	line_horizontal down_x, down_y+controls_size, controls_size, 066ff33h
	
	draw_symbol_macro 4, area, down_x+10, down_y+10
	
	;buton pentru left
	line_horizontal left_x, left_y, controls_size, 066ff33h
	line_horizontal left_x, left_y+controls_size, controls_size, 066ff33h
	line_vertical left_x, left_y, controls_size, 066ff33h
	line_vertical left_x+controls_size, left_y, controls_size, 066ff33h
	
	draw_symbol_macro 5, area, left_x+10, left_y+10
	
	;buton pentru right
	line_horizontal right_x, right_y, controls_size, 066ff33h
	line_horizontal right_x, right_y+controls_size, controls_size, 066ff33h
	line_vertical right_x, right_y, controls_size, 066ff33h
	line_vertical right_x+controls_size, right_y, controls_size, 066ff33h
	
	draw_symbol_macro 6, area, right_x+10, right_y+10
	;mov matrice_joc[0], 9

	mov matrice_joc[0], 9
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PUNE IN MATRICEA_JOC PE COORDONATELE WARM_X SI WARM_Y <= 10, DIN 30 IN 30 SECUNDE 

worm_apple_food :
	
	xor ebx, ebx 
	mov eax, counter
	mov ebx, 30
	div ebx 
	
	cmp edx, 0 
	jl afiseaza_matrice_joc
	ja afiseaza_matrice_joc
	
generate_worm :

	mov eax, index_worm 
	mov matrice_joc[eax], 0
	generate_x_y
	mov worm_x, eax 
	
	generate_x_y
	mov worm_y, eax 
	
	mov eax, worm_y
	mov ebx, symbol_size
	mul ebx 
	add eax, worm_x 
	cmp eax, index_food
	je generate_worm
	
	shl eax, 2
	mov index_worm, eax 
	mov matrice_joc[eax], 10
	

	 
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; AFISEAZA MATRICE_JOC ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

	draw_symbol_macro matrice_joc[0], area, 0, 0

afiseaza_matrice_joc :

	mov i, 0
for_i :

	mov j, 0   				; j trebuie facut 0 pentru fiecare i nu inainte de bucla
	for_j :
	
	mov eax, i 
	mov ebx, symbol_size
	mul ebx 
	add eax, j 
	shl eax, 2 
	
	mov ecx, eax 
	
	mov eax, i
	mov ebx, symbol_size
	mul ebx 
	push eax 
	
	mov eax, j
	mov ebx, symbol_size
	mul ebx 
	
	pop ebx 
	
	draw_symbol_macro matrice_joc[ecx], area, eax, ebx
	
	inc j 
	cmp j,symbol_size
	jl for_j  ;;; end bucla for j 
	
	inc i 
	cmp i, symbol_size
	je out_for 
	jmp for_i
	
out_for :	

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  VERIF DACA SNAKE CRESTE  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


mov ebx, head 
mov eax, dword ptr [ebx+i_list]
mov ecx, symbol_size
mul ecx 
add eax, dword ptr[ebx+j_list]
shl eax, 2 

cmp matrice_joc[eax], 8 							; good apple food 
je sarpele_creste_cu_un_element 
cmp matrice_joc[eax], 9 							; wall
je sarpele_moare
cmp matrice_joc[eax], 10
je sarpele_scade_cu_un_element 

jmp out_verif_sarpe

sarpele_creste_cu_un_element : 

	adauga_snake_elem_macro 0,0
	good_apple_food
	mov eax, 1
	mov ecx, scor_food
	add eax, ecx
	mov scor_food, eax 
	
	mov eax, scor_joc
	mov ecx, 20
	add eax, ecx
	mov scor_joc, eax 
	
	jmp out_verif_sarpe 
	

sarpele_moare : 
	mov scor_food, 0
	mov scor_joc, 0
	mov scor_worm, 0
	jmp start_joc
	
	
sarpele_scade_cu_un_element: 

	sterge_snake_elem_macro 
	
	mov eax, index_worm 
	mov matrice_joc[eax], 0
	generate_x_y
	mov worm_x, eax 
	
	generate_x_y
	mov worm_y, eax 
	
	mov eax, worm_y
	mov ebx, symbol_size
	mul ebx 
	add eax, worm_x 
	cmp eax, index_food
	je generate_worm
	
	mov eax, 1
	mov ecx, scor_worm
	add eax, ecx
	mov scor_worm, eax 
	
	mov eax, scor_joc
	mov ecx, 10
	sub eax, ecx
	mov scor_joc, eax 
	
	mov eax, scor_worm
	mov ebx, scor_food
	cmp eax, ebx 
	jg start_joc
	
	jmp out_verif_sarpe 


	
out_verif_sarpe :


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; VERIF DACA SARPELE S-A MUSCAT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_snake_macro
	

mov ebx, head 
mov ecx, dword ptr [ebx+next]
mov elem_curent, ecx  						; in elem curent se afla al doilea element 
cmp elem_curent, ebx 
je out_verif_sarpele_se_musca 

mov ebx, head 
mov eax, dword ptr [ebx+i_list]
mov ecx, symbol_size
mul ecx 
add eax, dword ptr [ebx+j_list] 			
mov index_snake_bite, eax 					; in index_snake_bite este indicele capului sarpelui  
bucla_verif_sarpele_se_musca :
	 
	mov ebx, elem_curent
	mov eax, dword ptr [ebx+i_list]
	mov ecx, symbol_size
	mul ecx 
	add eax, dword ptr [ebx+j_list]
	cmp index_snake_bite, eax 
	je start_joc
	
	 
	mov ecx, dword ptr [ebx+next]
	mov elem_curent, ecx 
	mov eax, head
	cmp elem_curent, eax  
	je out_verif_sarpele_se_musca 
	jmp bucla_verif_sarpele_se_musca
	
	
out_verif_sarpele_se_musca :
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; AFISARE SI MUTARE SARPE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	 
	mov ebx, head 
	mov elem_curent, ebx 
	
	 mov eax, dword ptr [ebx+i_list]
	 mov ecx, 20
	 mul ecx 
	
	 mov ecx, eax 				; in ecx este coord i la care afisam sarpele 
	
	 mov eax, dword ptr[ebx+j_list]
	 mov edx, 20
	 mul edx 
	 mov edx, eax 				; in eax este coord j la care afisam sarpele 
	draw_symbol_macro 1, area, eax, ecx 
	
	 mov eax, [ebx+next]			; in eax se afla emenentul urmator 
	 mov elem_curent, eax 
	
 bucla_afisare_sarpe :
	
	 mov ebx, elem_curent
	 mov eax, dword ptr [ebx+i_list]
	 mov ecx, 20
	 mul ecx 
	
	 mov ecx, eax 				; in ecx este coord i la care afisam sarpele 
	
	 mov eax, dword ptr[ebx+j_list]
	 mov edx, 20
	 mul edx 
	 mov edx, eax 				; in eax este coord j la care afisam sarpele 
	
	draw_symbol_macro 2, area, eax, ecx 
	
	
	 mov eax, [ebx+next]			; in eax se afla emenentul urmator 
	 mov elem_curent, eax 
	 mov ebx, head 
	 cmp ebx, eax 
	 je out_bucla_afisare_sarpe 
	 jmp bucla_afisare_sarpe
	
out_bucla_afisare_sarpe :


jmp end_start_joc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; start game ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

game_over :

jmp end_start_joc 
start_joc :

	mov counter, 0
	mov scor_food, 0
	mov scor_joc, 0
	mov scor_worm, 0 
	good_apple_food 
	create_snake_head_macro 10, 10 
	adauga_snake_elem_macro 10, 11
	
	
end_start_joc:

	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start

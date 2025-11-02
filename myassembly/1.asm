assume cs:codesg

codesg segment

fishcc: mov ax,2000H
        mov ds,ax
        mov bx,1000H
        mov ax,[bx]
        inc bx
        inc bx
        mov word ptr [bx],ax
        inc bx
        inc bx
        mov word ptr [bx],ax
        inc bx
        mov byte ptr [bx],al
        inc bx
        mov byte ptr [bx],al

codesg ends

end fishcc

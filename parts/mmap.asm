; mmap
;
; Block device that maps to memory.
;
; *** DEFINES ***
; MMAP_START: Memory address where the mmap begins

; *** VARIABLES ***
MMAP_PTR	.equ	MMAP_RAMSTART
MMAP_RAMEND	.equ	MMAP_PTR+2

; *** CODE ***

; Increase mem pointer by one
_mmapForward:
	ld	hl, (MMAP_PTR)
	inc	hl
	ld	(MMAP_PTR), hl
	ret

; Returns absolute addr of memory pointer in HL.
_mmapAddr:
	push	de
	ld	hl, (MMAP_PTR)
	ld	de, MMAP_START
	add	hl, de
	jr	nc, .end
	; we have carry? out of bounds, set to maximum
	ld	hl, 0xffff
.end:
	pop	de
	ret

; if out of bounds, will continually return the last char
mmapGetC:
	push	hl
	call	_mmapAddr
	ld	a, (hl)
	call	_mmapForward
	pop	hl
	ret

mmapPutC:
	push	hl
	call	_mmapAddr
	ld	(hl), a
	call	_mmapForward
	pop	hl
	ret

mmapSeek:
	ld	(MMAP_PTR), hl
	ret


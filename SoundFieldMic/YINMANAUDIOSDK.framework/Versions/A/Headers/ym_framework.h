// api
#include "ym_const.h"

/***************************************************************
*   Get the quantity of the memory required by convolve 
*****************************************************************/
unsigned int  ym_9con_query();


/***********************************************
*   Get the quantity of the memory required 
************************************************/
int  ym_9con_open(void *p0, unsigned int	N);

/******************************************
*	Processing data of frame
********************************************/
#if 0==AUD_DATA_FMT_TYPE
void ym_proc_fram(int						*out,
									int						*read,
#elif 1==AUD_DATA_FMT_TYPE
void ym_proc_fram(short					*out,
									short					*read,
#endif
									unsigned int	nRead,
												void		*p0);

/***************************************************************
* Get the parameters of the song which need to be processed 
* re-initialize some parameters when switching songs
*****************************************************************/
void ym_song_ini(unsigned int		nChnIn,
								 unsigned int		sampleStride,
								 void						*p0);

/***************************************************************
* Set the parameters of the DSP which control the performance of reverb_mono
*****************************************************************/
void ym_setPara_reverbMono(int		gainRvb,
													 int		dlyFramN,
													 void		*p0);

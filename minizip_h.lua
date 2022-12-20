--combined result of cpp zip.h and cpp unzip.h (only base functions without the wrappers)
local ffi = require'ffi'

ffi.cdef[[
enum {
	UNZ_OK                          = 0,
	UNZ_EOF                         = 0,
	UNZ_ERRNO                       = -1,
	UNZ_END_OF_LIST_OF_FILE         = -100,
	UNZ_PARAMERROR                  = -102,
	UNZ_BADZIPFILE                  = -103,
	UNZ_INTERNALERROR               = -104,
	UNZ_CRCERROR                    = -105,
	UNZ_BADPASSWORD                 = -106
};

enum {
	APPEND_STATUS_CREATE        = 0,
	APPEND_STATUS_CREATEAFTER   = 1,
	APPEND_STATUS_ADDINZIP      = 2
};

typedef struct {int unused;} zipFile_s;
typedef zipFile_s* zipFile;

typedef struct
{
    uint32_t    dos_date;
    uint16_t    internal_fa;        /* internal file attributes        2 bytes */
    uint32_t    external_fa;        /* external file attributes        4 bytes */
} zip_fileinfo;

zipFile zipOpen64 (const void *pathname, int append);

int zipOpenNewFileInZip4_64 (
	zipFile file,
	const char* filename,
	const zip_fileinfo* zipfi,
	const void* extrafield_local,  uint16_t size_extrafield_local,
	const void* extrafield_global, uint16_t size_extrafield_global,
	const char* comment,
	uint16_t method,
	int level,
	int raw,
	int windowBits,
	int memLevel,
	int strategy,
	const char* password,
	uint32_t crcForCrypting,
	uint16_t versionMadeBy,
	uint16_t flagBase,
	int zip64);

int zipWriteInFileInZip (zipFile file, const void* buf, uint32_t len);
int zipCloseFileInZip (zipFile file);
int zipCloseFileInZipRaw64 (zipFile file, uint64_t uncompressed_size, uint32_t crc32);
int zipClose (zipFile file, const char* global_comment);
int zipRemoveExtraInfoBlock (char* pData, int* dataLen, short sHeader);

/* unzip.h */

typedef struct {int unused;} unzFile_s;
typedef unzFile_s* unzFile;

/* unz_global_info structure contain global data about the ZIPfile
   These data comes from the end of central dir */
typedef struct unz_global_info64_s
{
	uint64_t number_entry;          /* total number of entries in the central dir on this disk */
	uint32_t number_disk_with_CD;   /* number the the disk with central dir, used for spanning ZIP*/
	uint16_t size_comment;          /* size of the global comment of the zipfile */
} unz_global_info64;

/* unz_file_info contain information about a file in the zipfile */
typedef struct unz_file_info64_s
{
    uint16_t version;               /* version made by                 2 bytes */
    uint16_t version_needed;        /* version needed to extract       2 bytes */
    uint16_t flag;                  /* general purpose bit flag        2 bytes */
    uint16_t compression_method;    /* compression method              2 bytes */
    uint32_t dos_date;              /* last mod file date in Dos fmt   4 bytes */
    uint32_t crc;                   /* crc-32                          4 bytes */
    uint64_t compressed_size;       /* compressed size                 8 bytes */
    uint64_t uncompressed_size;     /* uncompressed size               8 bytes */
    uint16_t size_filename;         /* filename length                 2 bytes */
    uint16_t size_file_extra;       /* extra field length              2 bytes */
    uint16_t size_file_comment;     /* file comment length             2 bytes */

    uint32_t disk_num_start;        /* disk number start               4 bytes */
    uint16_t internal_fa;           /* internal file attributes        2 bytes */
    uint32_t external_fa;           /* external file attributes        4 bytes */

    uint64_t disk_offset;

    uint16_t size_file_extra_internal;
} unz_file_info64;

typedef int (*unzFileNameComparer)(unzFile file, const char *filename1, const char *filename2);

unzFile unzOpen64 (const void *path);
int unzClose (unzFile file);
int unzGetGlobalInfo64 (unzFile file, unz_global_info64 *pglobal_info);
int unzGetGlobalComment (unzFile file, char *szComment, uint16_t comment_size);
int unzGoToFirstFile (unzFile file);
int unzGoToNextFile (unzFile file);
int unzLocateFile (unzFile file, const char *szFileName, unzFileNameComparer filename_compare_func);

typedef struct unz64_file_pos_s
{
    uint64_t pos_in_zip_directory;   /* offset in zip file directory */
    uint64_t num_of_file;            /* # of file */
} unz64_file_pos;

int unzGetFilePos64(unzFile file, unz64_file_pos* file_pos);
int unzGoToFilePos64(unzFile file, const unz64_file_pos* file_pos);

int unzGetCurrentFileInfo64 (unzFile file, unz_file_info64 *pfile_info, char *szFileName, uint16_t fileNameBufferSize,
	void *extraField, uint16_t extraFieldBufferSize, char *szComment, uint16_t commentBufferSize);
uint64_t unzGetCurrentFileZStreamPos64 (unzFile file);
int unzOpenCurrentFile3 (unzFile file, int* method, int* level, int raw, const char* password);
int unzCloseCurrentFile (unzFile file);
int unzReadCurrentFile (unzFile file, void* buf, uint32_t len);
uint64_t unztell64 (unzFile file);
int unzeof (unzFile file);
int unzGetLocalExtrafield (unzFile file, void* buf, uint32_t len);
uint64_t unzGetOffset64 (unzFile file);
int unzSetOffset64 (unzFile file, uint64_t pos);

/* minishared.h */

/* Get a file's date and time in dos format */
uint32_t get_file_date(const char *path, uint32_t *dos_date);

/* Sets a file's date and time in dos format */
void change_file_date(const char *path, uint32_t dos_date);

/* Create a directory and all subdirectories */
int makedir(const char *newdir);

/* Check to see if a file exists */
int check_file_exists(const char *path);

/* Convert dos date/time format to time_t */
long dosdate_to_time_t(uint32_t dos_date);

/* Convert time_t to dos date/time format */
uint32_t time_t_to_dosdate(long tm_t);

/* command line utilites */

int zip_run(int argc, const char *argv[]);
int unzip_run(int argc, const char *argv[]);
]]

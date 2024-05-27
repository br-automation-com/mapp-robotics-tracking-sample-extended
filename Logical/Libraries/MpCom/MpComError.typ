
TYPE
	MpComErrorEnum : 
		( (* Error numbers of library MpCom *)
		mpCOM_NO_ERROR := 0, (* No error *)
		mpCOM_ERR_ACTIVATION := -1064239103, (* Could not create component [Error: 1, 0xc0910001] *)
		mpCOM_ERR_MPLINK_NULL := -1064239102, (* MpLink is NULL pointer [Error: 2, 0xc0910002] *)
		mpCOM_ERR_MPLINK_INVALID := -1064239101, (* MpLink connection not allowed [Error: 3, 0xc0910003] *)
		mpCOM_ERR_MPLINK_CHANGED := -1064239100, (* MpLink modified [Error: 4, 0xc0910004] *)
		mpCOM_ERR_MPLINK_CORRUPT := -1064239099, (* Invalid MpLink contents [Error: 5, 0xc0910005] *)
		mpCOM_ERR_LINK_NOT_POSSIBLE := -1064238848, (* Connection not possible [Error: 256, 0xc0910100] *)
		mpCOM_ERR_FILE_SYSTEM := -1064238847, (* Error editing file [Error: 257, 0xc0910101] *)
		mpCOM_ERR_INVALID_FILE_DEV := -1064238846, (* Invalid file device [Error: 258, 0xc0910102] *)
		mpCOM_ERR_INVALID_FILE_NAME := -1064238845, (* Invalid filename [Error: 259, 0xc0910103] *)
		mpCOM_ERR_NO_CONFIG_IMPORT := -1064238844, (* No configuration data was imported [Error: 260, 0xc0910104] *)
		mpCOM_ERR_MISSING_UICONNECT := -1064238843, (* Missing value on UIConnect [Error: 261, 0xc0910105] *)
		mpCOM_ERR_CONFIG_IMPORT_ERR := -1064238842, (* A syntax error was detected in the config-import file [Error: 262, 0xc0910106] *)
		mpCOM_ERR_WRONG_FILTER_STRING := -1064238841, (* Error in the filter string [Error: 263, 0xc0910107] *)
		mpCOM_ERR_COMPONENT_NOT_FOUND := -1064238840, (* The given mapp-component was not found [Error: 264, 0xc0910108] *)
		mpCOM_ERR_CONFIG_ACCESS_FAILED := -1064238839, (*Access to the requested configuration failed [Error: 265, 0xc0910109]*)
		mpCOM_ERR_CONFIG_READ_FAILED := -1064238838, (*Reading configuration has failed [Error: 266, 0xc091010a]*)
		mpCOM_ERR_CONFIG_WRITE_FAILED := -1064238837, (*Writing configuration has failed [Error: 267, 0xc091010b]*)
		mpCOM_ERR_CONFIG_NOT_OPEN := -1064238836, (*Configuration not open [Error: 268, 0xc091010c]*)
		mpCOM_ERR_CONFIG_COPY_FAILED := -1064238835, (*Copying configuration has failed [Error: 269, 0xc091010d]*)
		mpCOM_ERR_CONFIG_INVALID_COPY := -1064238834, (*Invalid copy (cannot copy to itself) [Error: 270, 0xc091010e]*)
		mpCOM_ERR_CONFIG_INVALID_DATA := -1064238833, (*Invalid data-pointer [Error: 271, 0xc091010f]*)
		mpCOM_WRN_CONFIG_PARAM_ACTIVE := -2137980656 (*Parameterization is active. Write to config has no immediate effect [Error: 273, 0x80910110]*)
		);
END_TYPE

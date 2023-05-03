___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "URL Build with Strip Query Data (By Zoly)",
  "description": "More advanced version of the URL variable.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "urlParts",
    "displayName": "URL parts",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "protocol",
        "checkboxText": "Protocol",
        "simpleValueType": true,
        "alwaysInSummary": true,
        "help": "e.g. http://, https://",
        "defaultValue": true
      },
      {
        "type": "CHECKBOX",
        "name": "host",
        "checkboxText": "Hostname",
        "simpleValueType": true,
        "alwaysInSummary": true,
        "help": "e.g. sub.domain.com",
        "defaultValue": true
      },
      {
        "type": "CHECKBOX",
        "name": "port",
        "checkboxText": "Port",
        "simpleValueType": true,
        "alwaysInSummary": true,
        "help": "e.g. :1313"
      },
      {
        "type": "CHECKBOX",
        "name": "path",
        "checkboxText": "Path",
        "simpleValueType": true,
        "alwaysInSummary": true,
        "help": "e.g. /download/file.html",
        "defaultValue": true
      },
      {
        "type": "CHECKBOX",
        "name": "extension",
        "checkboxText": "Extension",
        "simpleValueType": true,
        "alwaysInSummary": true,
        "help": "e.g. .html"
      },
      {
        "type": "CHECKBOX",
        "name": "query",
        "checkboxText": "Query string",
        "simpleValueType": true,
        "alwaysInSummary": true,
        "help": "e.g. ?client\u003dtrue\u0026id\u003dabcd1234",
        "defaultValue": true
      },
      {
        "type": "CHECKBOX",
        "name": "fragment",
        "checkboxText": "Fragment",
        "simpleValueType": true,
        "alwaysInSummary": true,
        "help": "e.g. #scroll-to-top",
        "enablingConditions": []
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "advancedSettings",
    "displayName": "Advanced settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "GROUP",
        "name": "pathControls",
        "displayName": "Path Controls",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "LABEL",
            "name": "Path String",
            "displayName": "Path"
          },
          {
            "type": "CHECKBOX",
            "name": "pathSlash",
            "checkboxText": "Insert / in path end",
            "simpleValueType": true,
            "alwaysInSummary": true,
            "defaultValue": false
          }
        ],
        "enablingConditions": [
          {
            "paramName": "path",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "stripControls",
        "displayName": "Strip Keys Controls",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "LABEL",
            "name": "queryString",
            "displayName": "Query String"
          },
          {
            "type": "CHECKBOX",
            "name": "urlStrip1",
            "checkboxText": "Strip key from query string",
            "simpleValueType": true,
            "alwaysInSummary": true,
            "defaultValue": false
          },
          {
            "type": "PARAM_TABLE",
            "name": "queryKeys",
            "displayName": "Query keys",
            "paramTableColumns": [
              {
                "param": {
                  "type": "TEXT",
                  "name": "queryKey",
                  "displayName": "",
                  "simpleValueType": true
                },
                "isUnique": true
              }
            ],
            "alwaysInSummary": true,
            "enablingConditions": [
              {
                "paramName": "urlStrip1",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "help": "Fetch and strip the this query keys/value from the query string. Use"
          }
        ],
        "enablingConditions": [
          {
            "paramName": "query",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const getUrl = require('getUrl');
const query = require('queryPermission');
const log = require('logToConsole');

const removeQueryParam = (keys, sourceQuerys) => {
        var keysArr = []; keys.forEach((value, key) => keysArr.push(value.queryKey));
        var param, rtn,
          params_arr = [],
          queryString = sourceQuerys;
      if (queryString !== "") {
          params_arr = queryString.split("&");
          for (var i = params_arr.length - 1; i >= 0; i = i - 1) {
              param = params_arr[i].split("=")[0].toLowerCase();
              if (keysArr.indexOf(param) > -1) {
                  params_arr.splice(i, 1);
              }
          }
          rtn = params_arr.join("&");
      }
  return rtn;
  //return log(rtn);
};


const addSlash = (path) => {
var pathLength = path.length;
if(path.substring(pathLength,pathLength-1) !== '/'){
    return path+'/';
  }
  return path;
};

const types = ['protocol', 'host', 'port', 'path', 'extension', 'query', 'fragment'];
let urlString = '';

types.forEach(type => {
  if (data[type]) {
    let str =  query('get_url', type) && getUrl(type);
    if (str === false) {
      return log('Missing permission to access URL ' + type);
    }
    if (str.length) {
      //return log(str);
      if (type === 'protocol') str += '://';
      if (type === 'port') str = ':' + str;
      if (type === 'extension') str = '.' + str;
      
      if (type === 'query'){
        
        if (data.urlStrip1) {
          str = '?' + removeQueryParam(data.queryKeys,str);
          //return log(str);
         }else{
            str = '?' + str;
         }
      }
      
      if(type == 'path' && data.pathSlash){
        str = addSlash(str);
      }
      
      if (type === 'fragment') str = '#' + str;
      urlString += str;
    }
  }
});

//return log(urlString);
return urlString;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 04/04/2023, 17:26:37



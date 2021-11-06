/* GRUPPO INTERFACCE modGUI v2.7
 * 12-12-19
 * LUCA SANTARELLA
 * EMANUELE URSELLI
 * STEFANIA FALCHI
 * FRANCESKO KUMANAKU
*/

create or replace package Costanti as
  stile constant varchar2(32767) := '
  
  ';

  jscript constant varchar2(32767) := '

  function checkTarga(value){
    if((value.length) == 0)
        return true;
    var regexp = /[a-z][a-z]\d\d\d[a-z][a-z]/i;
    return regexp.test(value) && value.length == 7;
  }

  function checkMail(value) {
    if (value.length == 0)
        return true;
    var regexp = /^[-a-z0-9~!$%^&*_=+}{\''?]+(\.[-a-z0-9~!$%^&*_=+}{\''?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i;
    return regexp.test(value);
  }

  function checkCF(value){
    if((value.length) == 0)
        return true;
    var regexp = /^[a-z0-9]+$/i;
    return regexp.test(value) && value.length == 16;
  }

  function checkText(value) {
    if (value.length == 0)
      return true;
    var regexp = /^[a-z]+$/i;
    return regexp.test(value);
  }

  function checkNumber(value) {
    if (value.length == 0)
      return true;
    var regexp = /^[0-9]+$/;
    return regexp.test(value);
  }
  '
  ;

  radice constant varchar2(20) := '/apex/santarella.'; -- Da sostituire (includere il punto)
  macchina2 constant varchar2(50) := 'http://131.114.73.204:8080'; --Togliere 8080

end Costanti;

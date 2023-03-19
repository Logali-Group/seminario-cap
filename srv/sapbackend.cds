using {sapbackend as external} from './external/sapbackend.csn';

define service SAPBackend {

    @cds.persistence : {
        table,
        skip : false
    }
    @cds.autoexpose
    entity Incidents as projection on external.IncidentsSet;


}

@protocol : 'rest'
define service RestService {
    entity Incidents as projection on SAPBackend.Incidents;
}

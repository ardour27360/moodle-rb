module MoodleRb
  class Enrolments
    include HTTParty
    include Utility

    attr_reader :token, :query_options
    STUDENT_ROLE_ID = 5
    TEACHER_ROLE_ID = 3
    USER_ROLE_ID = 1

    def initialize(token, url, query_options)
      @token = token
      @query_options = query_options
      self.class.base_uri url
    end

    # required params:
    # user_id course_id
    def create(params)
      role = params[:teacher] ? TEACHER_ROLE_ID : STUDENT_ROLE_ID
      role = USER_ROLE_ID if params[:exit]
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('enrol_manual_enrol_users', token),
          :body => {
            :enrolments => {
              '0' => {
                :userid => params[:user_id],
                :courseid => params[:course_id],
                :roleid => role
              }
            }
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.code == 200 && response.parsed_response.nil?
    end

    def unassign_role(params)
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('core_role_unassign_roles', token),
          :body => {
            :unassignments => {
              '0' => {
                :roleid => params[:role_id],
                :userid => params[:user_id],
                :contextid => params[:course_id],
                :contextlevel => 'course',
                :instanceid => ''
              }
            }
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.code == 200 && response.parsed_response.nil?
    end

    def destroy(params)
      role = params[:teacher] ? TEACHER_ROLE_ID : STUDENT_ROLE_ID
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('enrol_manual_unenrol_users', token),
          :body => {
            :enrolments => {
              '0' => {
                :userid => params[:user_id],
                :courseid => params[:course_id],
                :roleid => role
              }
            }
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.code == 200 && response.parsed_response.nil?
    end
  end
end

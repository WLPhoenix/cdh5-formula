{% if salt['pillar.get']('cdh5:security:enable', False) %}

{% from 'krb5/settings.sls' import krb5 with context %}
{% set realm = krb5.realm %}

generate_ticket:
  cmd:
    - run
    - name: kinit -kt /etc/hbase/conf/hbase.keytab hbase/{{ grains.fqdn }}@{{ realm }}
    - user: hbase

grant_permissions:
  cmd:
    - run
    - name: echo "grant '{{ pillar.__stackdio__.username }}', 'RWXCA'; grant 'oozie', 'RWXCA'" | hbase shell
    - user: hbase
    - require:
      - cmd: generate_ticket

{% endif %}

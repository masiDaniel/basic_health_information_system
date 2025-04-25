from rest_framework import serializers
from .models import Program
from accounts.models import ClientProfile  

class ProgramSerializer(serializers.ModelSerializer):
    clients = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=ClientProfile.objects.all(),
        required=False  
    )

    class Meta:
        model = Program
        fields = ['id', 'name', 'clients']

    def create(self, validated_data):
        request = self.context.get('request')
        doctor = request.user.doctorprofile  
        clients = validated_data.pop('client', [])
        program = Program.objects.create(doctor=doctor, **validated_data)
        program.clients.set(clients)
        return program
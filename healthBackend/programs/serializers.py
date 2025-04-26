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
        fields = "__all__"

    def create(self, validated_data):
        request = self.context.get('request')
        doctor = validated_data.pop('doctor', None)
        clients = validated_data.pop('client', [])
        program = Program.objects.create(doctor=doctor, **validated_data)
        program.clients.set(clients)
        return program
    
class ClientProgramSerializer(serializers.ModelSerializer):

    class Meta:
        model = Program
        exclude = ['clients']
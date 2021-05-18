using UnityEngine;

public class SetPositionAndRotation : MonoBehaviour
{
	public int amountToEmit;
	public ParticleSystem itsParticleSystem;


	public  void EmitOnPositionAndRotation ( 
		Transform reference,  
		Vector3 position, 
		Quaternion rotation)
	{

	}

#if UNITY_EDITOR
	private void OnValidate ( )
	{
		if ( itsParticleSystem == null ) itsParticleSystem = GetComponent<ParticleSystem> ( );
	}
#endif
}

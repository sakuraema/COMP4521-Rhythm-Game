using UnityEngine;

public class DescendsTransformYRotationToShapeModuleRotation : MonoBehaviour
{
	public ParticleSystem targetParticleSystem;
	private ParticleSystem.ShapeModule adjustedModule = new ParticleSystem.ShapeModule();
	private Vector3 adjustedRotation = new Vector3();


	public void PassRotation ( )
	{
		adjustedModule = targetParticleSystem.shape;
		adjustedRotation = adjustedModule.rotation;
		adjustedRotation.y = transform.rotation.eulerAngles.y;
		adjustedModule.rotation = adjustedRotation;
	}
}
